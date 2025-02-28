import 'package:flutter/material.dart';
import '../widget/detail.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<bool> isReadList = [];

  final List<Map<String, String>> mockData = [
    {
      "title": "แจ้งเตือน1",
      "content": "123456",
      "noti_date": "2025-02-17",
      "created_by": "dee"
    },
    {
      "title": "แจ้งเตือน2",
      "content": "789456",
      "noti_date": "2025-02-18",
      "created_by": "ดี้"
    },
    {
      "title": "แจ้งเตือน3",
      "content": "123456789",
      "noti_date": "2025-02-19",
      "created_by": "ดี้"
    },
  ];

  @override
  void initState() {
    super.initState();
    isReadList = List.generate(mockData.length, (index) => false);
  }

  void _markAsRead(int index) {
    setState(() {
      isReadList[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการแจ้งเตือน"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: mockData.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final item = mockData[index];
          final isRead = isReadList[index];

          return InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: item),
                ),
              );
              _markAsRead(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isRead ? Colors.white : Colors.purple[50],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"]!,
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 16,
                            color: isRead ? Colors.black : Colors.deepPurple,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          item["content"]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item["noti_date"]!,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
