import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_palette.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = <NavItem>[
      NavItem(icon: Icons.home_outlined, label: 'home'.tr),
      NavItem(icon: Icons.chat_bubble_outline, label: 'chat'.tr),
      NavItem(icon: Icons.search, label: 'search'.tr),
      NavItem(icon: Icons.calendar_today_outlined, label: 'session'.tr),
      NavItem(icon: Icons.person_outline, label: 'profile'.tr),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.darkSurface : AppPalette.lightSurface, // أو AppPalette.lightSurface / darkSurface
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == selectedIndex;

            // Gradient colors based on theme
            final gradientColors = isDark
                ? [Color(0xFF3B3B70), Color(0xFF0B0A3F)] // أغمق للدارك مود
                : [Color(0xFF2D8CFF), Color(0xFF0D035F)]; // Light

            if (isSelected) {
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-0.4, -0.3),
                          radius: 1.0,
                          colors: gradientColors,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors.last.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Unselected items
            final iconColor = isDark
                ? AppPalette.darkTextSecondary.withOpacity(0.7)
                : AppPalette.lightTextSecondary.withOpacity(0.7);

            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: iconColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  NavItem({required this.icon, required this.label});
}