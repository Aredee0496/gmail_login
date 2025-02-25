import 'package:flutter/material.dart';
import '../service/group-service.dart';

class AdminControls extends StatefulWidget {
  final VoidCallback toggleDeleteMode;
  final VoidCallback toggleAddMode;
  final VoidCallback toggleSelectMode;

  AdminControls({required this.toggleDeleteMode, required this.toggleAddMode, required this.toggleSelectMode});

  @override
  _AdminControlsState createState() => _AdminControlsState();
}

class _AdminControlsState extends State<AdminControls>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GroupService groupService = GroupService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isMenuOpen)
          GestureDetector(
            onTap: toggleMenu,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: 0.5,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildAnimatedActionButton(2, Icons.check, "แก้ไข", () {
                widget.toggleSelectMode();
                toggleMenu();
              }),
              _buildAnimatedActionButton(1, Icons.delete, "ลบ", () {
                widget.toggleDeleteMode();
                toggleMenu();
              }),
              _buildAnimatedActionButton(0, Icons.add, "เพิ่ม", () {
                widget.toggleAddMode();
                toggleMenu();
              }),
              FloatingActionButton(
                heroTag: "main_fab",
                onPressed: toggleMenu,
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: CircleBorder(),
                child:
                    Icon(isMenuOpen ? Icons.close : Icons.more_vert, size: 28),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedActionButton(
      int index, IconData icon, String tooltip, VoidCallback onPressed) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -(_animation.value * (index + 1) * 10)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: FloatingActionButton(
        heroTag: "fab_$index",
        mini: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(icon, size: 24),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
