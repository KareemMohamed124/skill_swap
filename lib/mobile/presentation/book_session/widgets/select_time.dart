import 'package:flutter/material.dart';
import '../../../../shared/core/theme/app_palette.dart';

class SelectTime extends StatefulWidget {
  final Function(String) onSelect;
  const SelectTime({super.key, required this.onSelect});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  final List<String> selectTime = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
  ];

  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fontSize = screenWidth * 0.035; // حجم الخط نسبي
    final borderRadius = screenWidth * 0.02; // نصف قطر نسبي
    final childAspectRatio =
        screenWidth / (screenHeight * 0.08); // نسبي للعرض والارتفاع

    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: screenWidth * 0.02,
      crossAxisSpacing: screenWidth * 0.02,
      childAspectRatio: childAspectRatio,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(selectTime.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onSelect(selectTime[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected ? AppPalette.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Center(
              child: Text(
                selectTime[index],
                style: TextStyle(
                  fontSize: fontSize,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? AppPalette.darkTextSecondary
                          : AppPalette.lightTextSecondary),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
