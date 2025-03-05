import 'package:flutter/material.dart';
import 'package:gmail/widget/background.dart';

class DetailActivity extends StatefulWidget {
  const DetailActivity({super.key});

  @override
  State<DetailActivity> createState() => _DetailActivityState();
}

class _DetailActivityState extends State<DetailActivity> {
  String? status;

  @override
  Widget build(BuildContext context) {
    const activityData =
        'Activity: วิ่งมาราธอน, Place: รอบโรงงาน, Start: 2025-02-28 08:00, End: 2025-02-28 12:00';

    final details = _parseActivityData(activityData);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("รายละเอียดกิจกรรม"),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('ชื่อกิจกรรม', details['Activity'] ?? '-'),
                    _buildDetailRow('สถานที่', details['Place'] ?? '-'),
                    _buildDetailRow('เริ่มเวลา', details['Start'] ?? '-'),
                    _buildDetailRow('สิ้นสุดเวลา', details['End'] ?? '-'),
                    SizedBox(height: 24),
                    if (status == null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            context,
                            'เข้าร่วม',
                            Colors.green,
                            'คุณได้เข้าร่วมกิจกรรมแล้ว',
                            'เข้าร่วมแล้ว',
                          ),
                          _buildActionButton(
                            context,
                            'ปฏิเสธ',
                            Colors.red,
                            'คุณได้ปฏิเสธการเข้าร่วม',
                            'ปฏิเสธแล้ว',
                          ),
                        ],
                      ),
                    ] else ...[
                      Center(
                        child: Text(
                          'สถานะ: $status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: status == 'เข้าร่วมแล้ว'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.event_note, color: Colors.blue),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, Color color,
      String message, String resultStatus) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        _showResponseDialog(context, message, resultStatus);
      },
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  void _showResponseDialog(
      BuildContext context, String message, String resultStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('การตอบรับกิจกรรม'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                status = resultStatus;
              });
            },
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Map<String, String> _parseActivityData(String data) {
    final Map<String, String> result = {};
    final parts = data.split(', ');

    for (var part in parts) {
      final pair = part.split(': ');
      if (pair.length == 2) {
        result[pair[0].trim()] = pair[1].trim();
      }
    }

    return result;
  }
}
