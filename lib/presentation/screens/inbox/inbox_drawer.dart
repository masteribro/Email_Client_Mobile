import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/email.dart';
import 'drawer_item.dart';

class InboxDrawer extends StatelessWidget {
  final EmailFolder currentFolder;
  final int unreadCount;
  final ValueChanged<EmailFolder> onFolderSelected;
  final VoidCallback onSignOut;

  const InboxDrawer({
    super.key,
    required this.currentFolder,
    required this.unreadCount,
    required this.onFolderSelected,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mail_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  DrawerItem(
                    icon: Icons.inbox_outlined,
                    selectedIcon: Icons.inbox,
                    label: AppStrings.inbox,
                    isSelected: currentFolder == EmailFolder.inbox,
                    badge: unreadCount,
                    onTap: () => onFolderSelected(EmailFolder.inbox),
                  ),
                  DrawerItem(
                    icon: Icons.star_border_outlined,
                    selectedIcon: Icons.star,
                    label: AppStrings.starred,
                    isSelected: currentFolder == EmailFolder.starred,
                    onTap: () => onFolderSelected(EmailFolder.starred),
                  ),
                  DrawerItem(
                    icon: Icons.send_outlined,
                    selectedIcon: Icons.send,
                    label: AppStrings.sent,
                    isSelected: currentFolder == EmailFolder.sent,
                    onTap: () => onFolderSelected(EmailFolder.sent),
                  ),
                  DrawerItem(
                    icon: Icons.drafts_outlined,
                    selectedIcon: Icons.drafts,
                    label: AppStrings.drafts,
                    isSelected: currentFolder == EmailFolder.drafts,
                    onTap: () => onFolderSelected(EmailFolder.drafts),
                  ),
                  DrawerItem(
                    icon: Icons.delete_outline,
                    selectedIcon: Icons.delete,
                    label: AppStrings.trash,
                    isSelected: currentFolder == EmailFolder.trash,
                    onTap: () => onFolderSelected(EmailFolder.trash),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout,
                        color: AppColors.textSecondary),
                    title: const Text(AppStrings.signOut,
                        style: TextStyle(color: AppColors.textSecondary)),
                    onTap: onSignOut,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}