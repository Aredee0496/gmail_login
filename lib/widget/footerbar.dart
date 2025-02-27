import 'package:flutter/material.dart';
import 'package:gmail/pages/detail_activity.dart';
import 'package:gmail/pages/gen_qr.dart';
import 'package:gmail/widget/qr_code_scanner.dart';

class FooterBar extends StatelessWidget {
  final Widget? adminControls;

  const FooterBar({Key? key, this.adminControls}) : super(key: key);

  void _scanQRCode(BuildContext context) {
    Navigator.push(
      context,
      // MaterialPageRoute(builder: (context) => const QRViewExample()),
      MaterialPageRoute(builder: (context) => const DetailActivity()),
    );
  }

  void _openGenQRPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GenQRPage()),
    );
  }

 @override
Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.grey.shade100,
        height: 70.0,
        child: Row(
            children: [
              if (adminControls != null)
               Expanded(
                child: IconButton(
                    icon: const Icon(Icons.qr_code, color: Colors.deepPurple),
                    onPressed: () => _openGenQRPage(context),
                ),
               ),
                Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Material(
                            elevation: 8,
                            shape: const CircleBorder(),
                            child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FloatingActionButton(
                                    onPressed: () => _scanQRCode(context),
                                    backgroundColor: Colors.deepPurple,
                                    child: const Icon(Icons.qr_code_scanner,
                                        color: Colors.white, size: 40),
                                ),
                            ),
                        ),
                    ),
                ),
                if (adminControls != null)
                    Expanded(
                        child: adminControls!,
                    ),
            ],
        ),
    );
}
}
