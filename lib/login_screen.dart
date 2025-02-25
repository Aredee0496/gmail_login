import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isButtonEnabled = false;
  static final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    getDeviceToken(context);
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
  }

    static Future getDeviceToken(BuildContext context,
      {int maxRetires = 3}) async {
    try {
      String? token;
      token = await _firebaseMessaging.getToken();
      print("for android device token: $token");
      return token;
    } catch (e) {
      print("failed to get device token");
      if (maxRetires > 0) {
        print("try after 10 sec");
        await Future.delayed(Duration(seconds: 10));
        return getDeviceToken(context, maxRetires: maxRetires - 1);
      } else {
        return null;
      }
    }
  } 

  void _validateFields() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  Future<void> loginWithEmail() async {
    setState(() => isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: ${e.toString()}")),
      );
    }
    setState(() => isLoading = false);
  }

  Future<void> loginWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: ${e.toString()}")),
      );
    }
    setState(() => isLoading = false);
  }

  Future<void> loginWithFacebook() async {
  setState(() => isLoading = true);
  try {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final AccessToken? accessToken = result.accessToken;
      if (accessToken != null) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null && userCredential.additionalUserInfo!.isNewUser) {
          final List<UserInfo> providers = user.providerData;
          bool hasGoogle = providers.any((p) => p.providerId == 'google.com');

          if (hasGoogle) {
            try {
              final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
              if (googleUser != null) {
                final GoogleSignInAuthentication googleAuth =
                    await googleUser.authentication;
                final AuthCredential googleCredential = GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );

                await user.linkWithCredential(googleCredential);
              }
            } catch (linkError) {
              print("Error linking accounts: $linkError");
            }
          }
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("เกิดข้อผิดพลาด: ${e.toString()}")),
    );
  }
  setState(() => isLoading = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade300, Colors.greenAccent.shade200],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/favicon.png'),
                    width: 180, 
                  ),
                  SizedBox(height: 20),
                  Text(
                    "SSJ",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(emailController, "อีเมล", Icons.email),
                  SizedBox(height: 10),
                  _buildTextField(passwordController, "รหัสผ่าน", Icons.lock,
                      isPassword: true),
                  SizedBox(height: 10),
                  _buildLoginButton(),
                  SizedBox(height: 20),
                  const Divider( 
                    color: Colors.white, 
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Text(
                    "หรือเข้าสู่ระบบด้วย",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  _buildSocialButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, String hint, IconData icon,
    {bool isPassword = false}) {
  return SizedBox(
    width: 300,
    height: 60,
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    ),
  );
  }

   Widget _buildLoginButton() {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading || !isButtonEnabled ? null : loginWithEmail,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          elevation: 5,
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.deepPurple)
            : Text(
                "เข้าสู่ระบบ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon("assets/google_logo.png", loginWithGoogle),
        SizedBox(width: 10),
        _buildSocialIcon("assets/facebook_logo.png", loginWithFacebook),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Image.asset(assetPath, height: 36),
      ),
    );
  }
}
