import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/email.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import '../../widgets/email_tile.dart';
import '../../widgets/empty_state_widget.dart';

String folderLabel(EmailFolder folder) => switch (folder) {
      EmailFolder.inbox => 'Inbox',
      EmailFolder.starred => 'Starred',
      EmailFolder.sent => 'Sent',
      EmailFolder.drafts => 'Drafts',
      EmailFolder.trash => 'Trash',
    };

IconData folderIcon(EmailFolder folder) => switch (folder) {
      EmailFolder.inbox => Icons.inbox_outlined,
      EmailFolder.starred => Icons.star_border_outlined,
      EmailFolder.sent => Icons.send_outlined,
      EmailFolder.drafts => Icons.drafts_outlined,
      EmailFolder.trash => Icons.delete_outline,
    };

String folderEmptySubtitle(EmailFolder folder) => switch (folder) {
      EmailFolder.inbox => 'Your inbox is empty.\nNew emails will appear here.',
      EmailFolder.starred =>
        'Star important emails\nand they\'ll show up here.',
      EmailFolder.sent => 'Emails you send\nwill appear here.',
      EmailFolder.drafts => 'Unfinished emails\nwill be saved here.',
      EmailFolder.trash => 'Deleted emails\nwill appear here.',
    };

class InboxBody extends StatelessWidget {
  final EmailState emailState;

  const InboxBody({super.key, required this.emailState});

  @override
  Widget build(BuildContext context) {
    if (emailState is EmailInitial ||
        (emailState is EmailLoading && emailState.allEmails.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (emailState is EmailError && emailState.allEmails.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                (emailState as EmailError).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.read<EmailCubit>().loadEmails(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final emails = emailState.currentEmails;

    if (emails.isEmpty) {
      return EmptyStateWidget(
        icon: folderIcon(emailState.currentFolder),
        title: 'No emails here',
        subtitle: folderEmptySubtitle(emailState.currentFolder),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<EmailCubit>().loadEmails(),
      child: ListView.separated(
        itemCount: emails.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final email = emails[index];
          return EmailTile(
            key: Key(email.id),
            email: email,
            onTap: () => context.push('/email/${email.id}'),
            onStarToggle: () =>
                context.read<EmailCubit>().toggleStar(email.id),
            onDelete: () => context.read<EmailCubit>().moveToTrash(email.id),
          );
        },
      ),
    );
  }
}