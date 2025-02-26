import 'package:flutter/material.dart';
import 'package:gmail/widget/qr_code_scanner.dart';

class FooterBar extends StatelessWidget {
  const FooterBar({Key? key}) : super(key: key);

  void _scanQRCode(BuildContext context) {
    print("Scanning QR Code...");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRViewExample()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade100,
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0), 
            child: Transform.scale(
              scale: 1.6, 
              child: FloatingActionButton(
                onPressed: () => _scanQRCode(context),
                backgroundColor: Colors.deepPurple,
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
