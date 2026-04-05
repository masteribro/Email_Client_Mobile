import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final int badge;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: AppColors.drawerSelectedTile,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected
              ? AppColors.drawerSelectedContent
              : AppColors.drawerIconUnselected,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.drawerSelectedContent
                : AppColors.drawerTextUnselected,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: badge > 0
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.drawerSelectedContent
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}