import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/common_ui/circle_button_icon.dart';

import '../../../constants/colors.dart';

import 'package:flutter/material.dart';

import '../../history/screens/history_screen.dart';

class SessionsHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String title;
  final String subtitle;

  const SessionsHeader({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.mainColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Row(
            children: [
              // GestureDetector(
              //   onTap: onBack,
              //   child: const Icon(
              //     Icons.arrow_back_ios,
              //     size: 18,
              //     color: AppColor.whiteColor,
              //   ),
              // ),
              // const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
             CircleButtonIcon(icon: Icons.history, onTap: (){Get.to(HistoryScreen());},),
              // IconButton(
              //   onPressed: onHistory,
              //   icon: const Icon(
              //     Icons.history,
              //     color: AppColor.whiteColor,
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 16),

          SelectStatus(
            selectedIndex: selectedIndex,
            onSelect: onSelect,
          ),
        ],
      ),
    );
  }
}


Widget SelectStatus({
  required int selectedIndex,
  required Function(int) onSelect,
}) {
  final List<String> statusList = [
    "All",
    "Pending",
    "Accepted",
    "Request",
  ];

  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(statusList.length, (index) {
      final isSelected = selectedIndex == index;

      return GestureDetector(
        onTap: () => onSelect(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.whiteColor : AppColor.selectedButtonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusList[index],
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColor.mainColor : AppColor.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }),
  );
}