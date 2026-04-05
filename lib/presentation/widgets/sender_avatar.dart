import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class SenderAvatar extends StatelessWidget {
  final String name;

  const SenderAvatar({super.key, required this.name});

  Color _colorForName(String name) {
    if (name.isEmpty) return AppColors.avatarColors[0];
    return AppColors.avatarColors[
        name.codeUnitAt(0) % AppColors.avatarColors.length];
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