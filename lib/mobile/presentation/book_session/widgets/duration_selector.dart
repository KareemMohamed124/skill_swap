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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final boxWidth = screenWidth * 0.12; // عرض نسبي
    final boxHeight = screenHeight * 0.08; // ارتفاع نسبي
    final fontSize = screenWidth * 0.035; // حجم الخط نسبي

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: durations.map((duration) {
        final bool isSelected = duration == selectedDuration;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDuration = duration;
            });
            widget.onSelect(duration);
          },
          child: Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              color:
                  isSelected ? AppPalette.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppPalette.primary
                    : Theme.of(context).dividerColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02), // padding نسبي
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
                      fontSize: fontSize,
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
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
