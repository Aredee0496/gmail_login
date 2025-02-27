import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation extends StatelessWidget {
  final User? user;

  const UserInformation({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: CircleAvatar(
              radius: 25,
              backgroundImage: user?.photoURL?.isNotEmpty == true
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/avatar.jpg')
                      as ImageProvider,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.displayName ?? 'ไม่พบชื่อผู้ใช้',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(user?.email ?? 'อีเมลไม่พบ',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
