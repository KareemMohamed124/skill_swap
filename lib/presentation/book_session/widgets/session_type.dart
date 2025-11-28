import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class SessionType extends StatelessWidget {
  final String sessionType;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const SessionType({
    super.key,
    required this.sessionType,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? const Color(0xFFE6E7FF)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColor.mainColor
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            // ---------- ICON ----------
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColor.mainColor
                    : const Color(0xFFE6E7FF),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColor.mainColor,
                size: 18,
              ),
            ),

            const SizedBox(width: 16),

            // ---------- TEXT ----------
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // ---------- DOT ----------
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.mainColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}