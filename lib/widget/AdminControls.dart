import 'package:flutter/material.dart';

class AdminControls extends StatefulWidget {
  final VoidCallback toggleDeleteMode;
  final VoidCallback toggleAddMode;
  final VoidCallback toggleSelectMode;

  AdminControls(
      {required this.toggleDeleteMode,
      required this.toggleAddMode,
      required this.toggleSelectMode});

  @override
  _AdminControlsState createState() => _AdminControlsState();
}

class _AdminControlsState extends State<AdminControls>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

   void toggleMenu() {
    if (isMenuOpen) {
      _overlayEntry.remove();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
    }
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildActionButton(Icons.check, "แจ้งเตือน", widget.toggleSelectMode),
              _buildActionButton(Icons.delete, "ลบ", widget.toggleDeleteMode),
              _buildActionButton(Icons.add, "เพิ่ม", widget.toggleAddMode),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildActionButton(IconData icon, String tooltip, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Opacity(
      opacity: 0.8,
      child: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(0.8), 
        radius: 24, 
        child: IconButton(
          icon: Icon(icon, size: 20, color: Colors.white), 
          onPressed: () {
            onPressed();
            toggleMenu();
          },
          tooltip: tooltip,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.deepPurple),
      onPressed: toggleMenu,
    );
  }

}
