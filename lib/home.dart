import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmail/service/app-service.dart';
import 'package:gmail/widget/AdminControls.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import './service/group-service.dart';
import 'model/group-model.dart';
import '../providers/role_provider.dart';
import './widget/dialog.dart';
import 'model/refresh-group-model.dart';
import 'package:badges/badges.dart' as badges;

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
  late String? accessToken;
  String? fcmToken;
  Set<String> notificationGroups = {};
  Set<String> selectedGroups = {};

  @override
  void initState() {
    super.initState();
    fetchGroupData();
    setupNotifications();
  }

  Future<void> setupNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String? groupName = message.data['groupName'];
      print("Received message for group: $groupName");
      print("Current Group List: $groupList");

      if (groupName != null) {
        List<String> groupNames =
            groupName.split(",").map((e) => e.trim()).toList();
        setState(() {
          for (var group in groupList) {
            if (groupNames.contains(group["name"])) {
              print("Match found! Updating ${group["name"]}");
              group["hasNotification"] = true;
            }
          }
        });
        Fluttertoast.showToast(
          msg: "New notification for group: $groupName",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          textColor: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 16.0,
        );
      }
    });
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
          RefreshGroups refreshData =
              await GroupService().getGroups(accessToken!);
          setState(() {
            groupList = refreshData.data.group.rows
                .map((row) => {"id": row.groupId, "name": row.groupName})
                .toList();
            isLoading = false;
          });
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

  void deleteGroup(String groupId, String accessToken) async {
    try {
      await GroupService().deleteGroup(accessToken, groupId);
      setState(() {
        groupList.removeWhere((group) => group["id"] == groupId);
        deleteMode = false;
        print("ลบ $groupId แล้ว");
      });
    } catch (e) {
      print("Error deleting group: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await AppService().Logout(accessToken!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    bool isAdmin = Provider.of<RoleProvider>(context).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าหลัก", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(user),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildUserInfo(user),
                if (isLoading)
                  CircularProgressIndicator()
                else
                  _buildGroupButtons(),
              ],
            ),
          ),
          if (isAdmin)
            AdminControls(
                toggleAddMode: toggleAddMode,
                toggleDeleteMode: toggleDeleteMode,
                toggleSelectMode: toggleSelectMode),
        ],
      ),
    );
  }

  Widget _buildDrawer(User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'ไม่พบชื่อผู้ใช้'),
            accountEmail: Text(user?.email ?? 'ไม่พบอีเมล'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ??
                  'https://www.example.com/default-avatar.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(User? user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user?.photoURL?.isNotEmpty == true
                    ? user!.photoURL!
                    : 'https://via.placeholder.com/150'),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.displayName ?? 'ชื่อผู้ใช้ไม่พบ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(user?.email ?? 'อีเมลไม่พบ',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupButtons() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: groupList.length,
            itemBuilder: (context, index) {
              String groupName = groupList[index]["name"]!;
              bool isSelected = selectedGroups.contains(groupName);

              Color buttonColor = selectMode
                  ? (isSelected
                      ? Colors.green.shade400
                      : Colors.deepPurple.shade400)
                  : Colors.deepPurple.shade400;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: buttonColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        if (selectMode) {
                          setState(() {
                            if (isSelected) {
                              selectedGroups.remove(groupName);
                            } else {
                              selectedGroups.add(groupName);
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(isSelected
                                    ? 'ยกเลิกเลือก: $groupName'
                                    : 'เลือก: $groupName')),
                          );
                        } else {
                          setState(() {
                            groupList[index]["hasNotification"] = false;
                            notificationGroups.remove(groupName);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('เลือก: $groupName')),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          groupName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  if (deleteMode)
                    Positioned(
                      top: 40, 
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteGroup(groupList[index]["id"], accessToken!);
                        },
                      ),
                    ),
                  badges.Badge(
                    showBadge: groupList[index]["hasNotification"] == true,
                    position: badges.BadgePosition.topEnd(
                        top: 4, end: -260),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Colors.red,
                      padding: EdgeInsets.all(10),
                    ),
                    child: SizedBox(width: 24, height: 24),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 50),
        if (selectMode)
          ElevatedButton(
            onPressed: selectedGroups.isNotEmpty ? _sendSelectedGroups : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
            child: Text(
              "ส่งกลุ่มที่เลือก",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
