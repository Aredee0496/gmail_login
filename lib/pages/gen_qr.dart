import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class GenQRPage extends StatefulWidget {
  const GenQRPage({Key? key}) : super(key: key);

  @override
  _GenQRPageState createState() => _GenQRPageState();
}

class _GenQRPageState extends State<GenQRPage> {
  final _formKey = GlobalKey<FormState>();
  final _activityNameController = TextEditingController();
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String? _qrData;
  GlobalKey _qrKey = GlobalKey();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

void _generateQRCode() {
  if (_formKey.currentState!.validate()) {
    final startDateStr = _startDate != null
        ? DateFormat('yyyy-MM-dd').format(_startDate!)
        : '';
    final startTimeStr =
        _startTime != null ? _startTime!.format(context) : '';
    final endDateStr =
        _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '';
    final endTimeStr = _endTime != null ? _endTime!.format(context) : '';

    final qrPayload = {
      "activity": _activityNameController.text,
      "start": "$startDateStr $startTimeStr",
      "end": "$endDateStr $endTimeStr",
    };

    setState(() {
      _qrData = jsonEncode(qrPayload); 
    });
  }
}

  Future<void> _saveQRCode() async {
    if (_qrData != null) {
      try {
        RenderRepaintBoundary boundary =
            _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        var status = await Permission.photos.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Permission denied! Please allow access from settings.')),
          );
          return;
        }

        final assetEntity = await PhotoManager.editor
            .saveImage(pngBytes, filename: 'qr_code.png');
        if (assetEntity != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR code saved to gallery!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save QR code.')),
          );
        }
      } catch (e) {
        print('Error saving QR code: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving QR code.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _activityNameController,
                decoration: const InputDecoration(labelText: 'Activity Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter activity name'
                    : null,
              ),
              ListTile(
                title: Text(_startDate == null
                    ? 'Select Start Date'
                    : DateFormat('yyyy-MM-dd').format(_startDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectStartDate(context),
              ),
              ListTile(
                title: Text(_startTime == null
                    ? 'Select Start Time'
                    : _startTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectStartTime(context),
              ),
              ListTile(
                title: Text(_endDate == null
                    ? 'Select End Date'
                    : DateFormat('yyyy-MM-dd').format(_endDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectEndDate(context),
              ),
              ListTile(
                title: Text(_endTime == null
                    ? 'Select End Time'
                    : _endTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectEndTime(context),
              ),
              ElevatedButton(
                onPressed: _generateQRCode,
                child: const Text('Generate QR Code'),
              ),
              if (_qrData != null) ...[
                Center(
                  child: RepaintBoundary(
                    key: _qrKey,
                    child: QrImageView(
                      data: _qrData!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveQRCode,
                  child: const Text('Save QR Code'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
