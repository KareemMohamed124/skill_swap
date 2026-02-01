import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/common_ui/circle_button_icon.dart';
import 'package:skill_swap/presentation/sessions/widgets/state_filter.dart';
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
      height: 188,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
                      style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
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

          StatusFilter(
            selectedIndex: selectedIndex,
            onSelect: onSelect,
          ),
        ],
      ),
    );
  }
}


Widget selectStatus({
  required BuildContext context,
  required int selectedIndex,
  required Function(int) onSelect,
}) {
  final List<String> statusList = [
    "All",
    "Accepted",
    "Pending",
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
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusList[index],
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }),
  );
}