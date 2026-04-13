import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/email.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import '../../widgets/email_tile.dart';
import '../../widgets/empty_state_widget.dart';

// ─── Folder helpers (used by InboxScreen too) ───────────────────────────────

String folderLabel(EmailFolder folder) => switch (folder) {
      EmailFolder.inbox => AppStrings.inbox,
      EmailFolder.starred => AppStrings.starred,
      EmailFolder.sent => AppStrings.sent,
      EmailFolder.drafts => AppStrings.drafts,
      EmailFolder.trash => AppStrings.trash,
    };

IconData folderIcon(EmailFolder folder) => switch (folder) {
      EmailFolder.inbox => Icons.inbox_outlined,
      EmailFolder.starred => Icons.star_border_outlined,
      EmailFolder.sent => Icons.send_outlined,
      EmailFolder.drafts => Icons.drafts_outlined,
      EmailFolder.trash => Icons.delete_outline,
    };

String folderEmptySubtitle(EmailFolder folder) => switch (folder) {
      EmailFolder.inbox => AppStrings.emptyInbox,
      EmailFolder.starred => AppStrings.emptyStarred,
      EmailFolder.sent => AppStrings.emptySent,
      EmailFolder.drafts => AppStrings.emptyDrafts,
      EmailFolder.trash => AppStrings.emptyTrash,
    };

// ─── Gmail-style inbox category tabs ────────────────────────────────────────

enum _Category { primary, social, promotions }

/// Classify an email into a Gmail inbox category based on the sender domain.
_Category _categorize(Email email) {
  final from = email.senderEmail.toLowerCase();

  const socialDomains = [
    'github.com',
    'linkedin.com',
    'twitter.com',
    'figma.com',
    'mail.notion.so',
    'slack.com',
  ];
  if (socialDomains.any(from.contains)) return _Category.social;

  const promoDomains = ['jumia.', 'newsletter', 'promo', 'deals', 'marketing'];
  if (promoDomains.any(from.contains)) return _Category.promotions;

  return _Category.primary;
}

// ─── InboxBody ───────────────────────────────────────────────────────────────

class InboxBody extends StatefulWidget {
  final EmailState emailState;

  const InboxBody({super.key, required this.emailState});

  @override
  State<InboxBody> createState() => _InboxBodyState();
}

class _InboxBodyState extends State<InboxBody> {
  String? _lastDeletedId;
  EmailFolder? _lastDeletedFolder;

  void _handleDelete(BuildContext context, Email email) {
    _lastDeletedId = email.id;
    _lastDeletedFolder = email.folder;

    context.read<EmailCubit>().moveToTrash(email.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppStrings.movedToTrash),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: AppStrings.undo,
          onPressed: () {
            if (_lastDeletedId != null && _lastDeletedFolder != null) {
              context.read<EmailCubit>().restoreFromTrash(
                    _lastDeletedId!,
                    _lastDeletedFolder!,
                  );
              _lastDeletedId = null;
              _lastDeletedFolder = null;
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailState = widget.emailState;

    // Loading spinner (first load only)
    if (emailState is EmailInitial ||
        (emailState is EmailLoading && emailState.allEmails.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error screen with retry
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
                emailState.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.read<EmailCubit>().loadEmails(),
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    void onDelete(Email email) => _handleDelete(context, email);

    // Inbox → Gmail-style category tabs
    if (emailState.currentFolder == EmailFolder.inbox) {
      return _InboxWithTabs(
        emails: emailState.currentEmails,
        onDelete: onDelete,
      );
    }

    // Other folders → flat list
    final emails = emailState.currentEmails;
    if (emails.isEmpty) {
      return EmptyStateWidget(
        icon: folderIcon(emailState.currentFolder),
        title: AppStrings.noEmailsHere,
        subtitle: folderEmptySubtitle(emailState.currentFolder),
      );
    }

    return _EmailListView(emails: emails, onDelete: onDelete);
  }
}

// ─── Gmail category tabs (Primary / Social / Promotions) ─────────────────────

class _InboxWithTabs extends StatelessWidget {
  final List<Email> emails;
  final void Function(Email) onDelete;

  const _InboxWithTabs({required this.emails, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final primary =
        emails.where((e) => _categorize(e) == _Category.primary).toList();
    final social =
        emails.where((e) => _categorize(e) == _Category.social).toList();
    final promotions =
        emails.where((e) => _categorize(e) == _Category.promotions).toList();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Sticky category tab bar
          Material(
            color: Colors.white,
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              dividerColor: AppColors.divider,
              tabs: [
                _CategoryTab(
                  label: 'Primary',
                  icon: Icons.inbox_outlined,
                  unreadCount: primary.where((e) => !e.isRead).length,
                ),
                _CategoryTab(
                  label: 'Social',
                  icon: Icons.people_outline,
                  unreadCount: social.where((e) => !e.isRead).length,
                ),
                _CategoryTab(
                  label: 'Promotions',
                  icon: Icons.local_offer_outlined,
                  unreadCount: promotions.where((e) => !e.isRead).length,
                ),
              ],
            ),
          ),
          // Swipeable tab content
          Expanded(
            child: TabBarView(
              children: [
                _TabContent(
                  emails: primary,
                  emptyIcon: Icons.inbox_outlined,
                  emptySubtitle: 'Personal messages will appear here',
                  onDelete: onDelete,
                ),
                _TabContent(
                  emails: social,
                  emptyIcon: Icons.people_outline,
                  emptySubtitle: 'Social network updates will appear here',
                  onDelete: onDelete,
                ),
                _TabContent(
                  emails: promotions,
                  emptyIcon: Icons.local_offer_outlined,
                  emptySubtitle: 'Deals, offers and promotions will appear here',
                  onDelete: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final int unreadCount;

  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
          if (unreadCount > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final List<Email> emails;
  final IconData emptyIcon;
  final String emptySubtitle;
  final void Function(Email) onDelete;

  const _TabContent({
    required this.emails,
    required this.emptyIcon,
    required this.emptySubtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      return EmptyStateWidget(
        icon: emptyIcon,
        title: AppStrings.noEmailsHere,
        subtitle: emptySubtitle,
      );
    }
    return _EmailListView(emails: emails, onDelete: onDelete);
  }
}

// ─── Reusable email list with pull-to-refresh ────────────────────────────────

class _EmailListView extends StatelessWidget {
  final List<Email> emails;
  final void Function(Email) onDelete;

  const _EmailListView({required this.emails, required this.onDelete});

  @override
  Widget build(BuildContext context) {
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
            onDelete: () => onDelete(email),
          );
        },
      ),
    );
  }
}