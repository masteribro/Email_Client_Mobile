import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/email.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/email/email_cubit.dart';
import '../../blocs/email/email_state.dart';
import 'inbox_body.dart';
import 'inbox_drawer.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;

        return BlocBuilder<EmailCubit, EmailState>(
          builder: (context, emailState) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: AppColors.surfaceGrey,
                elevation: 0,
                toolbarHeight: 64,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Material(
                    elevation: 2,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white,
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          Builder(
                            builder: (ctx) => IconButton(
                              icon: const Icon(Icons.menu,
                                  color: AppColors.textPrimary),
                              onPressed: () =>
                                  Scaffold.of(ctx).openDrawer(),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.push('/search'),
                              child: Text(
                                AppStrings.searchInMail,
                                style: const TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          if (emailState is EmailLoading)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                if (authState is AuthAuthenticated) {
                                  _showAccountSheet(
                                    context,
                                    authState.user,
                                    authState.savedAccounts,
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  user != null && user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              drawer: InboxDrawer(
                currentFolder: emailState.currentFolder,
                unreadCount: emailState.inboxUnreadCount,
                onFolderSelected: (folder) {
                  Navigator.of(context).pop();
                  context.read<EmailCubit>().setFolder(folder);
                },
                onSignOut: () {
                  Navigator.of(context).pop();
                  context.read<AuthCubit>().logout();
                },
                onSettings: () {
                  Navigator.of(context).pop();
                  context.push('/settings');
                },
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show folder label for every folder except inbox
                  // (inbox uses category tabs instead)
                  if (emailState.currentFolder != EmailFolder.inbox)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        folderLabel(emailState.currentFolder),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  Expanded(child: InboxBody(emailState: emailState)),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => context.push('/compose'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text(AppStrings.compose),
                backgroundColor: AppColors.fabBackground,
                foregroundColor: AppColors.fabForeground,
                elevation: 3,
              ),
            );
          },
        );
      },
    );
  }

  void _showAccountSheet(
    BuildContext context,
    User activeUser,
    List<User> savedAccounts,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _AccountSheet(
        activeUser: activeUser,
        savedAccounts: savedAccounts,
        onSwitchAccount: (user) {
          Navigator.of(ctx).pop();
          context.read<AuthCubit>().switchAccount(user);
        },
        onAddAccount: () {
          Navigator.of(ctx).pop();
          context.push('/login');
        },
        onSignOut: () {
          Navigator.of(ctx).pop();
          context.read<AuthCubit>().logout();
        },
        onSettings: () {
          Navigator.of(ctx).pop();
          context.push('/settings');
        },
      ),
    );
  }
}

class _AccountSheet extends StatelessWidget {
  final User activeUser;
  final List<User> savedAccounts;
  final ValueChanged<User> onSwitchAccount;
  final VoidCallback onAddAccount;
  final VoidCallback onSignOut;
  final VoidCallback onSettings;

  const _AccountSheet({
    required this.activeUser,
    required this.savedAccounts,
    required this.onSwitchAccount,
    required this.onAddAccount,
    required this.onSignOut,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final otherAccounts =
        savedAccounts.where((u) => u.id != activeUser.id).toList();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.mail_rounded,
                      color: Colors.white, size: 15),
                ),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 20, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Active account
          _AccountTile(
            user: activeUser,
            isActive: true,
            onTap: null,
            onManage: onSettings,
          ),
          // Other saved accounts
          if (otherAccounts.isNotEmpty) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...otherAccounts.map(
              (u) => _AccountTile(
                user: u,
                isActive: false,
                onTap: () => onSwitchAccount(u),
                onManage: null,
              ),
            ),
          ],
          const Divider(height: 1),
          // Add another account
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_add_outlined,
                  color: AppColors.textPrimary, size: 20),
            ),
            title: const Text(AppStrings.addAccount,
                style: TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
            onTap: onAddAccount,
          ),
          // Sign out
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout,
                  color: AppColors.textPrimary, size: 20),
            ),
            title: const Text(AppStrings.signOutAll,
                style: TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
            onTap: onSignOut,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final User user;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onManage;

  const _AccountTile({
    required this.user,
    required this.isActive,
    required this.onTap,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: isActive ? 24 : 20,
              backgroundColor: isActive
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.75),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isActive ? 20 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: isActive ? 15 : 14,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  if (isActive && onManage != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: onManage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        AppStrings.manageAccount,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isActive)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}