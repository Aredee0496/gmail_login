import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRViewExample extends StatefulWidget {
  QRViewExample({Key? key}) : super(key: key);

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String scannedData = "Scan a QR code";
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.deepPurple),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    onDetect: (barcodeCapture) {
                      if (isScanning) {
                        final barcode = barcodeCapture.barcodes.first;
                        if (barcode.rawValue != null) {
                          setState(() {
                            scannedData = barcode.rawValue!;
                            isScanning = false;
                          });
                        }
                      }
                    },
                  ),
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    scannedData,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
