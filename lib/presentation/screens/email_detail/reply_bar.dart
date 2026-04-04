import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/email.dart';

class ReplyBar extends StatelessWidget {
  final Email email;

  const ReplyBar({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final isSent = email.folder == EmailFolder.sent;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
        ),
        child: Row(
          children: [
            if (!isSent)
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.reply, size: 18),
                  label: const Text('Reply'),
                  onPressed: () => context.push('/compose', extra: {
                    'replyToEmail': email.senderEmail,
                    'replyToName': email.senderName,
                    'replySubject': 'Re: ${email.subject}',
                  }),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            if (!isSent) const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.forward, size: 18),
                label: const Text('Forward'),
                onPressed: () => context.push('/compose', extra: {
                  'replySubject': 'Fwd: ${email.subject}',
                }),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}