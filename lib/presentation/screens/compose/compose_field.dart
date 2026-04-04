import 'package:flutter/material.dart';

class ComposeField extends StatelessWidget {
  final String prefix;
  final Widget child;

  const ComposeField({super.key, required this.prefix, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              prefix,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5F6368),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}