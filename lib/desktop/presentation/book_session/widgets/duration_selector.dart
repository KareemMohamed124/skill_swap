import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class DurationSelector extends StatefulWidget {
  final Function(int) onSelect;
  const DurationSelector({super.key, required this.onSelect});

  @override
  State<DurationSelector> createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  final List<int> durations = [30, 45, 60, 90, 120];

  int selectedDuration = 60;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 👈 اسكرول عرضي
      child: Row(
        children: durations.map((duration) {
          final bool isSelected = duration == selectedDuration;

          return Padding(
            padding: const EdgeInsets.only(right: 8), // 👈 المسافة بين البوكسات
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDuration = duration;
                });
                widget.onSelect(duration);
              },
              child: Container(
                width: 59,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppPalette.primary
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppPalette.primary
                        : Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      duration.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                            ? AppPalette.darkTextSecondary
                            : AppPalette.lightTextSecondary),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "min",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                            ? AppPalette.darkTextSecondary
                            : AppPalette.lightTextSecondary),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}