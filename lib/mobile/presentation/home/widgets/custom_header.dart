import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../../../../shared/core/theme/app_palette.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.2, // بدل 160
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.primary,
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // بدل 16
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.075, // بدل 30
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: (defaultTargetPlatform == TargetPlatform.windows)
                  ? null
                  : (avatarPath != null && avatarPath!.isNotEmpty
                  ? FileImage(File(avatarPath!))
                  : null),
              child: (defaultTargetPlatform == TargetPlatform.windows ||
                  avatarPath == null || avatarPath!.isEmpty )
                  ?Icon(
                Icons.person,
                size: screenWidth * 0.075,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              )
                  : null,
            ),

            SizedBox(width: screenWidth * 0.02), // بدل 8

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // بدل 16
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005), // بدل 4
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03, // بدل 12
                      ),
                    ),
                  ),
                ],
              ),
            ),

            circleButton(
              context: context,
              icon: Icons.notifications_none,
              onTap: onIcon2,
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget circleButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
    required double screenWidth,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02), // بدل 8
          child: Icon(
            icon,
            size: screenWidth * 0.04, // بدل 16
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}