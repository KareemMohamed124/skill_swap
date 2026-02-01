import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_palette.dart';

class CustomHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarPath;
  final VoidCallback? onIcon1;
  final VoidCallback? onIcon2;

  const CustomHeader({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarPath,
    this.onIcon1,
    this.onIcon2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ========= CircleAvatar =========
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage:
              avatarPath != null && avatarPath!.isNotEmpty
                  ? FileImage(File(avatarPath!))
                  : null,
              child: avatarPath == null || avatarPath!.isEmpty
                  ? Icon(Icons.person, size: 30, color: Theme.of(context).textTheme.bodyLarge!.color)
                  : null,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            circleButton(
              context: context,
              icon: Icons.notifications_none,
              onTap: onIcon2,
            ),
          ],
        ),
      ),
    );
  }

  Widget circleButton({required BuildContext context ,required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).textTheme.bodyLarge!.color
          ),
        ),
      ),
    );
  }
}