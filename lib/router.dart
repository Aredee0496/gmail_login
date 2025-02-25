import 'package:flutter/material.dart';
import 'package:gmail/home.dart';
import 'package:gmail/login_screen.dart';
import 'package:gmail/notilist.dart';

myRoutes(BuildContext context) {
  return {
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/notilist': (context) => const Message()
  };
}
