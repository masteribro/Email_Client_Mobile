import 'package:flutter/material.dart';

class SenderAvatar extends StatelessWidget {
  final String name;

  const SenderAvatar({super.key, required this.name});

  Color _colorForName(String name) {
    const colors = [
      Color(0xFF1A73E8),
      Color(0xFFE91E63),
      Color(0xFF9C27B0),
      Color(0xFF00897B),
      Color(0xFFE53935),
      Color(0xFF43A047),
      Color(0xFF8E24AA),
      Color(0xFFD81B60),
      Color(0xFF039BE5),
      Color(0xFFFF7043),
    ];
    if (name.isEmpty) return colors[0];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 22,
      backgroundColor: _colorForName(name),
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}