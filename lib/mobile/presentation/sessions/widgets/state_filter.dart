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

    final statusList = ["all".tr, "accepted".tr, "pending".tr, "request".tr];

    return Wrap(
      spacing: 8,
      children: List.generate(statusList.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.15)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.4)
                    : colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              statusList[index],
              style: TextStyle(
                fontSize: 13,
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