import 'dart:io';
import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';

class CustomHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarPath; // ده path الصورة لو موجودة
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
      decoration: const BoxDecoration(
        color: AppColor.mainColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ========= CircleAvatar =========
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage:
              avatarPath != null && avatarPath!.isNotEmpty
                  ? FileImage(File(avatarPath!))
                  : null,
              child: avatarPath == null || avatarPath!.isEmpty
                  ? const Icon(Icons.person, size: 30, color: AppColor.mainColor)
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
                      color: AppColor.whiteColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            circleButton(
              icon: Icons.notifications_none,
              onTap: onIcon2,
            ),
          ],
        ),
      ),
    );
  }

  Widget circleButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
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
            color: AppColor.mainColor,
          ),
        ),
      ),
    );
  }
}