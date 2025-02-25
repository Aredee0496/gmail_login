import 'package:flutter/material.dart';

class GroupDialog {
  static void showAddGroupDialog(BuildContext context, Function(String) onGroupNameSubmitted) {
    final TextEditingController groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("เพิ่มกลุ่มใหม่"),
          content: TextField( 
            controller: groupNameController,
            decoration: InputDecoration(hintText: "กรุณาใส่ชื่อกลุ่ม"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String groupName = groupNameController.text;
                if (groupName.isNotEmpty) {
                  onGroupNameSubmitted(groupName);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("กรุณากรอกชื่อกลุ่ม"))
                  );
                }
              },
              child: Text("เพิ่ม"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ยกเลิก"),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteConfirmationDialog(BuildContext context, String groupId, Function(String) onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณแน่ใจหรือไม่ว่าต้องการลบกลุ่มนี้?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(groupId);
              },
              child: Text("ลบ", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
