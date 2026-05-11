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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final statusList = ["accepted".tr, "pending".tr, "request".tr, "rejected"];

    return Wrap(
      spacing: screenWidth * 0.01,
=======
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final statusList = ["accepted".tr, "pending".tr, "request".tr];

    return Wrap(
      spacing: screenWidth * 0.02, // responsive spacing
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      children: List.generate(statusList.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onSelect(index),
<<<<<<< HEAD
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025,
              vertical: screenWidth * 0.012,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected ? Color(0xFFE68C47) : colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),
            ),
            child: Text(
              statusList[index],
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w600,
<<<<<<< HEAD
                color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
=======
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),
            ),
          ),
        );
      }),
    );
  }
}
