import 'package:flutter/material.dart';

BoxDecoration Background() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.deepPurple,
        Colors.white,
      ],
    ),
  );
}
