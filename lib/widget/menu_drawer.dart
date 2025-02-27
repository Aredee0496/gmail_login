import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmail/pages/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MenuDrawer extends StatelessWidget {
  final User? user;

  MenuDrawer({super.key, required this.user});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'ไม่พบชื่อผู้ใช้'),
            accountEmail: Text(user?.email ?? 'ไม่พบอีเมล'),
            currentAccountPicture: CircleAvatar(
              radius: 25,
              backgroundImage: user?.photoURL?.isNotEmpty == true
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/avatar.jpg') as ImageProvider,
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
