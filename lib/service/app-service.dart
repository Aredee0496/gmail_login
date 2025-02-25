import 'dart:convert';
import 'package:http/http.dart';
import '../config/env.dart';

class AppService {
  Future<void> Notification(
      String firebaseToken, String  groupName) async {
    try {
      final url = Uri.https(URL_API_APP, "$VERSION_API_APP/noti/notigroup");
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $firebaseToken"
      };
      final body = jsonEncode({"groups": "$groupName"});
      final response = await post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Set notification success");
      } else {
        throw Exception("Failed to logout");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> Logout(String firebaseToken) async {
    try {
      final url = Uri.https(URL_API_APP, "$VERSION_API_APP/sylogin/signout");
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $firebaseToken"
      };
      final response = await get(url, headers: headers);
      if (response.statusCode == 200) {
        print("Logout success");
      } else {
        throw Exception("Failed to logout");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
