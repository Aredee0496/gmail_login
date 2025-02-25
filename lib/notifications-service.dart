import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gmail/main.dart';


class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  // get the fcm device token
  static Future getDeviceToken(BuildContext context,
      {int maxRetires = 3}) async {
    try {
      String? token;
      // if (kIsWeb) {
      //   // get the device fcm token
      //   token = await _firebaseMessaging.getToken(
      //       vapidKey:
      //           "BPA9r_00LYvGIV9GPqkpCwfIl3Es4IfbGqE9CSrm6oeYJslJNmicXYHyWOZQMPlORgfhG8RNGe7hIxmbLXuJ92k");
      //   print("for web device token: $token");
      // } else {
      // get the device fcm token
      token = await _firebaseMessaging.getToken();
      print("for android device token: $token");
      // }
      // saveTokentoFirestore(token: token!);
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

  // static saveTokentoFirestore({required String token}) async {
  //   StorageApp _storageApp = StorageApp();
  //   bool isUserLoggedin = await _storageApp.getAuthenticated();
  //   print("User is logged in $isUserLoggedin");
  //   if (isUserLoggedin) {
  //     await CRUDService.saveUserToken(token!);
  //     print("save to firestore");
  //   }
  //   // also save if token changes
  //   _firebaseMessaging.onTokenRefresh.listen((event) async {
  //     if (isUserLoggedin) {
  //       await CRUDService.saveUserToken(token!);
  //       print("save to firestore");
  //     }
  //   });
  // }

  // initalize local notifications
  static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(

            // onDidReceiveLocalNotification: (id, title, body, payload) => null,
            );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // request notification permissions for android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/home", arguments: notificationResponse);
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    try {
      // final decode = jsonDecode(payload);
      // final id = int.parse(decode["GroupId"]);
      String? currentPath;
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });
      if (currentPath == "/home") {
        // navigatorKey.currentContext!
        //     .read<MenuNotiModel>()
        //     .updateShowNotiMenuId(id);
        print("go to home");
      }
    } catch (e) {
      print("${e}");
    }

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  // Future<ResCheckStatusModel> updateTokenNoti(
  //     BuildContext context, String body) async {
  //   StorageApp storageApp = StorageApp();
  //   AppService appService = AppService();
  //   try {
  //     String token = await storageApp.getAccessToken();
  //     final url = Uri.https(URL_API_APP, "$VERSION_API_APP/noti/");
  //     final headers = {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     };

  //     final response = await post(url, headers: headers, body: body);
  //     if (appService.checkExpired(response.statusCode)) {
  //       final res = await appService.generateAccessToken(context);
  //       if (res != null) {
  //         return updateTokenNoti(context, body);
  //       } else {
  //         return throw ("Token Expired");
  //       }
  //     } else if (response.statusCode == 200) {
  //       ResCheckStatusModel data =
  //           ResCheckStatusModel.fromJson(jsonDecode(response.body));
  //       if (data.code == 200) {
  //         if (data.result == 'success') {
  //           return data;
  //         } else {
  //           return throw (data.message);
  //         }
  //       } else if (appService.checkExpired(data.code)) {
  //         final res = await appService.generateAccessToken(context);
  //         if (res != null) {
  //           return updateTokenNoti(context, body);
  //         } else {
  //           return throw ("Token Expired");
  //         }
  //       } else {
  //         return throw (data.message);
  //       }
  //     } else {
  //       if (response.statusCode == 503 || response.statusCode == 502) {
  //         return throw ("${response.statusCode}: ${response.reasonPhrase}");
  //       } else {
  //         ResponseModel data =
  //             ResponseModel.fromJson(jsonDecode(response.body));
  //         return throw (data.message);
  //       }
  //     }
  //   } catch (e) {
  //     return throw ("$e");
  //   }
  // }

//   saveTokenNoti(BuildContext context) async {
//     String res = "";
//     try {
//       final token = await PushNotifications.getDeviceToken(context);
//       if (token != null) {
//         final temp = {
//           "Token": token,
//         };
//         final body = jsonEncode(temp);
//         final response =
//             await PushNotifications().updateTokenNoti(context, body);
//         if (response.result != "success") {
//           res = response.message;
//         } else {
//           res = "";
//         }
//       }
//     } catch (e) {
//       res = "${e}";
//     }

//     return res;
//   }
}
