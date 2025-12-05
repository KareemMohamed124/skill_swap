import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/constants/colors.dart';
import 'package:skill_swap/presentation/search/widgets/price_filter_section.dart';
import '../../../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../bloc/mentor_filter_bloc/mentor_filter_event.dart';

class MentorFilterSheet extends StatefulWidget {
  const MentorFilterSheet({super.key});

  @override
  State<MentorFilterSheet> createState() => _MentorFilterSheetState();
}

class _MentorFilterSheetState extends State<MentorFilterSheet> {
  double startPrice = 20;
  double endPrice = 60;

  int? selectedRate;
  String? selectedStatus;
  String? selectedTrack;
  String? enteredSkill;

  int activeFiltersCount = 0;

  final List<String> statuses = ["Available"];
  final List<String> tracks = ["Frontend", "Mobile", "AI", "Ui/Ux", "Backend"];
  final List<int> rates = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
      ),
      child: ListView(
        children: [
          const Text(
            "Filters",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          PriceFilterSection(
            min: 10,
            max: 100,
            onChanged: (start, end) {
              setState(() {
                if (startPrice == 20 && endPrice == 60 && (start != 20 || end != 60)) {
                  activeFiltersCount++;
                }
                startPrice = start;
                endPrice = end;
              });
            },
          ),

          const SizedBox(height: 16),

          const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          buildChoiceChips<String>(
            items: statuses,
            selectedItem: selectedStatus,
            onSelected: (value) {
              setState(() {
                if (selectedStatus == null && value != null) {
                  activeFiltersCount++;
                }
                else if (selectedStatus != null && value == null) {
                  activeFiltersCount--;
                }
                selectedStatus = value;
              });
            },
          ),

          const SizedBox(height: 16),

          const Text("Track", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          buildChoiceChips<String>(
            items: tracks,
            selectedItem: selectedTrack,
            onSelected: (value) {
              setState(() {
                if (selectedTrack == null && value != null) {
                  activeFiltersCount++;
                }
                else if (selectedTrack != null && value == null) {
                  activeFiltersCount--;
                }
                selectedTrack = value;
              });
            },
          ),

          const SizedBox(height: 16),

          const Text("Skill", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.grayColor,
                hintText: "Enter skill name...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.mainColor.withValues(alpha: 0.8),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  final trimmed = value.trim();
                  if (enteredSkill == null && trimmed.isNotEmpty) {
                    activeFiltersCount++;
                  } else if (enteredSkill != null && trimmed.isEmpty) {
                    activeFiltersCount--;
                  }
                  enteredSkill = trimmed.isEmpty ? null : trimmed;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          const Text("Rating", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          buildChoiceChips<int>(
            items: rates,
            selectedItem: selectedRate,
            onSelected: (value) {
              setState(() {
                if (selectedRate == null && value != null) {
                  activeFiltersCount++;
                } else if (selectedRate != null && value == null) {
                  activeFiltersCount--;
                }
                selectedRate = value;
              });
            },
            showIcon: true,
            icon: Icons.star,
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.grayColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: AppColor.mainColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<MentorFilterBloc>().add(
                    ApplyFiltersEvent(
                      minPrice: startPrice,
                      maxPrice: endPrice,
                      minRate: selectedRate?.toDouble(),
                      status: selectedStatus,
                      track: selectedTrack,
                      skill: enteredSkill,
                    ),
                  );

                  Navigator.pop(context, activeFiltersCount);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildChoiceChips<T>({
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onSelected,
    Color activeColor = AppColor.mainColor,
    Color inactiveColor = AppColor.grayColor,
    bool showIcon = false,
    IconData? icon,
  }) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final active = selectedItem == item;
        return ChoiceChip(
          label: showIcon
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: active ? AppColor.whiteColor : activeColor,
              ),
              Text(
                "  $item",
                style: TextStyle(
                  color: active ? AppColor.grayColor : activeColor,
                ),
              ),
            ],
          )
              : Text(
            "$item",
            style: TextStyle(
              color: active ? AppColor.grayColor : activeColor,
            ),
          ),
          selected: active,
          backgroundColor: inactiveColor,
          selectedColor: activeColor,
          checkmarkColor: inactiveColor,
          onSelected: (_) {
            onSelected(active ? null : item);
          },
        );
      }).toList(),
    );
  }
}