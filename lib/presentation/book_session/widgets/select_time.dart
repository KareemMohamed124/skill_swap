import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';

class SelectTime extends StatefulWidget {
  final Function(String) onSelect;
  const SelectTime({super.key, required this.onSelect});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  final List<String> selectTime = [
    "09:00 AM", "10:00 AM","11:00 AM",
    "12:00 PM", "01:00 PM","02:00 PM",
    "03:00 PM", "04:00 PM","05:00 PM",
    "06:00 PM", "07:00 PM","08:00 PM",
  ];

  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.4,
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
              color: isSelected ? AppColor.mainColor: AppColor.grayColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                selectTime[index],
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColor.blackColor,
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