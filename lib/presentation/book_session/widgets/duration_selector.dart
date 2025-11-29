import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';

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
            width: 59,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.mainColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.mainColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    duration.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "min",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 12,
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