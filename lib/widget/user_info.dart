import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation  extends StatelessWidget {
  final User? user;

  const UserInformation ({super.key, this.user});

  @override
  Widget build(BuildContext context) {
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
}
