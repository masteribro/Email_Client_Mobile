import 'package:flutter/material.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/email.dart';

Color senderColor(String name) {
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

class EmailBody extends StatelessWidget {
  final Email email;

  const EmailBody({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email.subject,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF202124),
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: senderColor(email.senderName),
                child: Text(
                  email.senderName.isNotEmpty
                      ? email.senderName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            email.senderName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF202124),
                            ),
                          ),
                        ),
                        Text(
                          DateFormatter.formatDetailDate(email.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5F6368),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email.senderEmail,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF5F6368)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'To: ${email.recipientEmail}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF5F6368)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          SelectableText(
            email.body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}