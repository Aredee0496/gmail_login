import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gmail/auth_wrapper.dart';
import 'package:local_auth/local_auth.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkAndAuthenticate();
  }

  Future<void> _checkAndAuthenticate() async {
    try {
      bool canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      
      if (!canAuthenticate) {
        _navigateToApp();
        return;
      }

      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'กรุณายืนยันตัวตนด้วยลายนิ้วมือ / Face ID หรือ PIN',
        options: AuthenticationOptions(
          biometricOnly: false, 
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (isAuthenticated) {
        _navigateToApp();
      } else {
        Future.delayed(Duration(seconds: 3), _checkAndAuthenticate);
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      _navigateToApp();
    }
  }

  void _navigateToApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.greenAccent.shade200],
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/favicon.png', width: 150),
              SizedBox(height: 20),
              Text(
                "ยินดีต้อนรับ",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
