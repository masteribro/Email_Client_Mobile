import 'package:flutter/material.dart';


class CredentialRow extends StatelessWidget {
  final String label;
  final String value;

  const CredentialRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: Color(0xFF5F6368)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF202124),
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}