import 'package:flutter/material.dart';
import 'package:gmail/main.dart';
import 'package:gmail/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          surface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'DB Heavent',
      ),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: myRoutes(context),
      onUnknownRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const Scaffold(
              body: Center(
                  child: Text(
            'Page Not Found',
            style: TextStyle(
              fontSize: 24,
            ),
          ))),
        );
      },
    );
  }
}
