import 'package:flutter/material.dart';
import 'package:gmail/widget/background.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, String> item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(item["title"]!),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        decoration: Background(),
        child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "เนื้อหา",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item["content"]!,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Divider(height: 30, thickness: 1, color: Colors.grey[300]),
                    Row(
                      children: [
                        Icon(Icons.date_range,
                            size: 18, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          "วันที่แจ้งเตือน: ${item["noti_date"]}",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.person, size: 18, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          "สร้างโดย: ${item["created_by"]}",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("ปิด"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
      ),
    );
  }
}
