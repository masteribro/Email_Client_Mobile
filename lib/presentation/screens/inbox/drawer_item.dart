import 'package:flutter/material.dart';

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
        selectedTileColor: const Color(0xFFD3E3FD),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected
              ? const Color(0xFF001D35)
              : const Color(0xFF444746),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF001D35)
                : const Color(0xFF1F1F1F),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: badge > 0
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF001D35)
                      : const Color(0xFF1A73E8),
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