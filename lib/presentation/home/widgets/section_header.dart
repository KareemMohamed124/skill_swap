import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class SectionHeader extends StatelessWidget {
  final String sectionTitle;
  final VoidCallback? onTop;
  const SectionHeader({
    super.key, required this.sectionTitle, required this.onTop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.blackColor
          ),
        ),
        GestureDetector(
          onTap: onTop,
          child: Row(
            children: [
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColor.blackColor,
              ),
            ],
          ),
        )
      ],
    );
  }
}

