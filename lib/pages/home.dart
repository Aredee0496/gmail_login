import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmail/service/app-service.dart';
import 'package:gmail/widget/AdminControls.dart';
import 'package:gmail/widget/menu_drawer.dart';
import 'package:provider/provider.dart';
import '../../providers/role_provider.dart';
import '../../service/group-service.dart';
import '../../model/group-model.dart';
import '../../widget/dialog.dart';
import '../../widget/footerbar.dart';
import '../../widget/user_info.dart';
import '../../widget/group_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> groupList = [];
  bool isLoading = true;
  bool deleteMode = false;
  bool addMode = false;
  bool selectMode = false;
  String? accessToken;
  Set<String> selectedGroups = {};
  Set<String> notificationGroups = {};

  @override
  void initState() {
    super.initState();
    fetchGroupData();
    setupNotifications();
  }

  Future<String?> getFirebaseToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("Firebase Token: $token");
      return token;
    } catch (e) {
      print("Error getting Firebase token: $e");
      return null;
    }
  }

  Future<void> setupNotifications() async {
    print("✅ setupNotifications() called");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("🔔 Received message: ${message.data}");

      String? groupName = message.data['groupName'];
      print("gsfgdfxhsdfhdfshrstj $groupName");
      if (groupName != null) {
        List<String> groupNames =
            groupName.split(",").map((e) => e.trim()).toList();
        setState(() {
          for (var group in groupList) {
            if (groupNames.contains(group["name"])) {
              print("✅ Match found! Updating ${group["name"]}");
              group["hasNotification"] = true;
            }
          }
        });
        print("📢 Updated groupList: $groupList");

        Fluttertoast.showToast(
          msg: "New notification for group: $groupName",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    });
  }

  void fetchGroupData() async {
    try {
      String? firebaseToken = await getFirebaseToken();
      GroupData groupData = await GroupService().fetchGroups(firebaseToken!);

      setState(() {
        groupList = groupData.data.group.rows
            .map((row) => {
                  "id": row.groupId,
                  "name": row.groupName,
                  "hasNotification": false,
                })
            .toList();

        accessToken = groupData.data.accesstoken;
        Provider.of<RoleProvider>(context, listen: false)
            .setAccessToken(accessToken!);
        Provider.of<RoleProvider>(context, listen: false)
            .setRole(groupData.data.admin);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching groups: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleAddMode() {
    addMode = !addMode;
    if (addMode) {
      GroupDialog.showAddGroupDialog(context, (groupName) async {
        if (accessToken != null) {
          await GroupService().addGroup(groupName, accessToken!);
          fetchGroupData();
        } else {
          print("Error: AccessToken is null");
        }
      });
    }
  }

  void toggleDeleteMode() {
    setState(() {
      deleteMode = !deleteMode;
    });
  }

  void toggleSelectMode() {
    setState(() {
      selectMode = !selectMode;
    });
  }

  void _sendSelectedGroups() async {
    if (selectedGroups.isNotEmpty) {
      await AppService().Notification(accessToken!, selectedGroups.join(","));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('ส่ง noti : ${selectedGroups.join(", ")} ไปแล้ว')),
      );
    }
  }

  void deleteGroup(String groupId) async {
    try {
      await GroupService().deleteGroup(accessToken!, groupId);
      setState(() {
        groupList.removeWhere((group) => group["id"] == groupId);
        deleteMode = false;
      });
    } catch (e) {
      print("Error deleting group: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      drawer: MenuDrawer(user: user),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  UserInformation(user: user),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    GroupButtonsWidget(
                      groupList: groupList,
                      selectedGroups: selectedGroups,
                      notificationGroups: notificationGroups,
                      selectMode: selectMode,
                      deleteMode: deleteMode,
                      onGroupSelect: (groupName) {
                        setState(() {
                          if (selectedGroups.contains(groupName)) {
                            selectedGroups.remove(groupName);
                          } else {
                            selectedGroups.add(groupName);
                          }
                        });
                      },
                      onGroupDelete: (groupId) {
                        deleteGroup(groupId);
                      },
                      onSendSelectedGroups: _sendSelectedGroups,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<RoleProvider>(
        builder: (context, roleProvider, child) {
          return FooterBar(
            adminControls: roleProvider.isAdmin ? child : null,
          );
        },
        child: AdminControls(
          toggleAddMode: toggleAddMode,
          toggleDeleteMode: toggleDeleteMode,
          toggleSelectMode: toggleSelectMode,
        ),
      ),
    );
  }
}
