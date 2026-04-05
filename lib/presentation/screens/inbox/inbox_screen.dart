import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
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
              appBar: AppBar(
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                title: Text(folderLabel(emailState.currentFolder)),
                actions: [
                  if (emailState is EmailLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () => _showAccountDialog(
                        context, user?.name ?? AppStrings.unknown, user?.email ?? ''),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
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
              ),
              body: InboxBody(emailState: emailState),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => context.push('/compose'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text(AppStrings.compose),
                backgroundColor: AppColors.fabBackground,
                foregroundColor: AppColors.fabForeground,
              ),
            );
          },
        );
      },
    );
  }

  void _showAccountDialog(BuildContext context, String name, String email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16)),
            Text(email,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthCubit>().logout();
            },
            child: const Text(AppStrings.signOut),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.close),
          ),
        ],
      ),
    );
  }
}