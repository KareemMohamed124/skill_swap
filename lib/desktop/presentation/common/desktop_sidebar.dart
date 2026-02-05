import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:skill_swap/desktop/presentation/common/unreal_card.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

class DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 220,
      color: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _item(Icons.home, "home".tr, 0),
                _item(Icons.chat, "chat".tr, 1),
                _item(Icons.search, "search".tr, 2),
                _item(Icons.schedule, "sessions".tr, 3),
                _item(Icons.person, "profile".tr, 4),
                _item(Icons.settings, "setting".tr, 5),
                _item(Icons.logout, "sign_out".tr, 6),
                _item(Icons.delete, "delete_account".tr, 7),
              ],
            ),
          ),

          const Divider(height: 20),

          Padding(
            padding: const EdgeInsets.all(8),
            child: UnrealExperienceCard(),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, int index) {
    final bool active = currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: GestureDetector(
        onTap: () => onItemSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: active ? AppPalette.primary.withValues(alpha: 0.15) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: active ? AppPalette.primary : null),
            title: Text(
              title,
              style: TextStyle(
                color: active ? AppPalette.primary : null,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}