import 'package:flutter/material.dart';
import 'package:gmail/widget/background.dart';
import 'detail.dart';

class ListScreen extends StatefulWidget {
  final String groupName;

  ListScreen({required this.groupName});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<bool> isReadList = [];
  late List<Map<String, String>> mockData;

  @override
  void initState() {
    super.initState();
    mockData = [
      {
        "title": "แจ้งเตือน 1",
        "content": "123456",
        "noti_date": "2025-02-17",
        "created_by": "dee"
      },
      {
        "title": "แจ้งเตือน 2",
        "content": "123456",
        "noti_date": "2025-02-17",
        "created_by": "dee"
      },
      {
        "title": "แจ้งเตือน 3",
        "content": "123456",
        "noti_date": "2025-02-17",
        "created_by": "dee"
      }
    ];
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
      extendBodyBehindAppBar: true,
      appBar:  AppBar(
      title: Text(widget.groupName),
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
              child: ListView.separated(
                itemCount: mockData.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey[300]),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                                    fontWeight: isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 16,
                                    color: isRead
                                        ? Colors.black
                                        : Colors.deepPurple,
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
                                    fontWeight: isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
