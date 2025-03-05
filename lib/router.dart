import 'package:flutter/material.dart';
import 'package:gmail/pages/home.dart';
import 'package:gmail/pages/login_screen.dart';
import 'package:gmail/notilist.dart';

myRoutes(BuildContext context) {
  return {
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/notilist': (context) => Message()
  };
}
