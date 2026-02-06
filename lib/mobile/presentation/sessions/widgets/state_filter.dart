import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const StatusFilter({
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final statusList = ["all".tr, "accepted".tr, "pending".tr, "request".tr];

    return Wrap(
      spacing: screenWidth * 0.02, // responsive spacing
      children: List.generate(statusList.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenWidth * 0.015,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.15)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.4)
                    : colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              statusList[index],
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        );
      }),
    );
  }
}
