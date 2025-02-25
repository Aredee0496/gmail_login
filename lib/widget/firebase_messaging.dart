// import 'dart:math';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📌 Message from background: ${message.notification?.title}");
// }

// Future<void> initializeFirebaseMessaging() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.max,
//   );

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       print("✅ Notification clicked with payload: ${response.payload}");
//     },
//   );

//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   print("📌 Authorization status: ${settings.authorizationStatus}");

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print("📩 Received message: ${message.messageId}");
//     print("📌 Title: ${message.notification?.title}");
//     print("📌 Body: ${message.notification?.body}");
//     print("📌 Data: ${message.data}");
  
//     showNotification(message);
//   });

//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// }

// Future<void> showNotification(RemoteMessage message) async {
//   try {
//     int notificationId = Random().nextInt(100000);
//     String title = message.notification?.title ?? 'No Title';
//     String body = message.notification?.body ?? 'No Body';

//     print("📌 Showing notification: ID=$notificationId, Title=$title, Body=$body");

//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         const AndroidNotificationDetails(
//       'high_importance_channel',
//       'High Importance Notifications',
//       channelDescription: 'This channel is used for important notifications.',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       playSound: true,
//     );

//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       notificationId,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: message.data.toString(),
//     );

//     print("✅ Notification shown successfully");
//   } catch (e) {
//     print("❌ Error showing notification: $e");
//   }
// }


