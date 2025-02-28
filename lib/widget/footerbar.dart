import 'package:flutter/material.dart';
import 'package:gmail/pages/detail_activity.dart';
import 'package:gmail/pages/gen_qr.dart';

class FooterBar extends StatelessWidget {
  final Widget? adminControls;

  const FooterBar({Key? key, this.adminControls}) : super(key: key);

  void _scanQRCode(BuildContext context) {
    Navigator.push(
      context,
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
    return SizedBox(
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomAppBar(
            color: Colors.grey.shade100,
            child: Container(height: 60), 
          ),
          if (adminControls != null)
          Positioned(
            left: 50,
            child: IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.deepPurple),
              iconSize: 28,
              onPressed: () => _openGenQRPage(context),
            ),
          ),
          if (adminControls != null)
            Positioned(
              right: 50,
              child: adminControls!,
            ),
          Positioned(
            top: -20,
            left: MediaQuery.of(context).size.width / 2 - 30, 
            child: GestureDetector(
              onTap: () => _scanQRCode(context),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
