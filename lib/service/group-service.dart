import 'dart:convert';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/env.dart';
import 'package:gmail/model/group-model.dart';
import 'package:gmail/model/refresh-group-model.dart';

class GroupService {
  User? user = FirebaseAuth.instance.currentUser;

  Future<GroupData> fetchGroups(String firebaseToken) async {
    try {
      // String loginType = user!.providerData.isNotEmpty ? user!.providerData[0].providerId : "unknown";
      final url = Uri.https(URL_API_APP, "$VERSION_API_APP/sylogin/newauth");
      final headers = {"Content-Type": "application/json"};
      final body = {
        'UserName': "Rusdee B",
        'Email': 'rbillatah@gmail.com',
        // 'Token': firebaseToken,
        // 'LoginType': loginType,
      };

      final response =
          await post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GroupData.fromJson(data);
      } else {
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> addGroup(String groupName, String accessToken) async {
    final url = Uri.https(URL_API_APP, "$VERSION_API_APP/msgroup");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    final body = jsonEncode({"GroupName": groupName, "Status": 1});
    try {
      final response = await post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("เพิ่มกลุ่มสำเร็จ: ${response.body}");
      } else {
        print("เพิ่มกลุ่มล้มเหลว: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("เกิดข้อผิดพลาด: $error");
    }
  }

  Future<void> deleteGroup(String accessToken, String groupId) async {
    final url = Uri.https(URL_API_APP, "$VERSION_API_APP/msgroup/$groupId");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    try {
      final response = await delete(url, headers: headers);

      if (response.statusCode == 200) {
        print("ลบสำเร็จ: ${response.body}");
      } else {
        print("ลบไม่สำเร็จ: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("เกิดข้อผิดพลาด: $error");
    }
  }

  Future<void> updateGroup(String oldName, String newName, String s) async {
    print("แก้ไขกลุ่มจาก $oldName เป็น $newName");
  }

  Future<RefreshGroups> getGroups(String accessToken) async {
    try {
      final url = Uri.https(
          URL_API_APP, "$VERSION_API_APP/msuser/user/${user!.displayName}");
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      };
      final response = await get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RefreshGroups.fromJson(data);
      } else {
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
