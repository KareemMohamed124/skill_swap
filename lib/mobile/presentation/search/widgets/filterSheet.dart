import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/search/widgets/price_filter_section.dart';

import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';

class MentorFilterSheet extends StatefulWidget {
  final double initialMinPrice;
  final double initialMaxPrice;
  final int? initialRate;
  final String? initialRole;
  final String? initialTrack;

  const MentorFilterSheet({
    super.key,
    this.initialMinPrice = 20,
    this.initialMaxPrice = 60,
    this.initialRate,
    this.initialRole,
    this.initialTrack,
  });

  @override
  State<MentorFilterSheet> createState() => _MentorFilterSheetState();
}

class _MentorFilterSheetState extends State<MentorFilterSheet> {
  late double startPrice;
  late double endPrice;

  int? selectedRate;
  String? selectedRole;
  String? selectedTrack;

  int activeFiltersCount = 0;

  final List<String> roles = ["Mentor", "Normal"];

  /// key = value sent to backend
  /// value = label shown in UI
  final Map<String, String> tracks = {
    "Mobile Development": "Mobile",
    "Frontend Development": "Frontend",
    "Backend Development": "Backend",
    "UI/UX Design": "UI/UX",
    "Artificial Intelligence": "AI",
    "Data Science": "Data",
    "Game Development": "Game",
    "CyberSecurity": "Security",
    "Cloud Computing": "Cloud",
  };

  final List<int> rates = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    startPrice = widget.initialMinPrice;
    endPrice = widget.initialMaxPrice;
    selectedRate = widget.initialRate;
    selectedRole = widget.initialRole;
    selectedTrack = widget.initialTrack;

    if (startPrice != 20 || endPrice != 60) activeFiltersCount++;
    if (selectedRate != null) activeFiltersCount++;
    if (selectedRole != null) activeFiltersCount++;
    if (selectedTrack != null) activeFiltersCount++;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Text("filters".tr,
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: screenWidth * 0.02),
              Divider(),
              SizedBox(height: screenWidth * 0.02),

              /// Price
              PriceFilterSection(
                min: 0,
                max: 100,
                onChanged: (start, end) {
                  setState(() {
                    if (startPrice == 20 &&
                        endPrice == 60 &&
                        (start != 20 || end != 60)) {
                      activeFiltersCount++;
                    }
                    startPrice = start;
                    endPrice = end;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.04),

              /// Role
              Text("role".tr, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: screenWidth * 0.02),
              buildChoiceChips<String>(
                context: context,
                items: roles,
                selectedItem: selectedRole,
                onSelected: (value) {
                  setState(() {
                    if (selectedRole == null && value != null) {
                      activeFiltersCount++;
                    } else if (selectedRole != null && value == null) {
                      activeFiltersCount--;
                    }
                    selectedRole = value;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.04),

              /// Track
              Text("track".tr, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: screenWidth * 0.02),
              buildChoiceChips<String>(
                context: context,
                items: tracks.keys.toList(),
                selectedItem: selectedTrack,
                onSelected: (value) {
                  setState(() {
                    if (selectedTrack == null && value != null) {
                      activeFiltersCount++;
                    } else if (selectedTrack != null && value == null) {
                      activeFiltersCount--;
                    }
                    selectedTrack = value;
                  });
                },
                labelBuilder: (item) => tracks[item]!,
              ),

              SizedBox(height: screenWidth * 0.04),

              /// Rating
              Text("rating".tr, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: screenWidth * 0.02),
              buildChoiceChips<int>(
                context: context,
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

              SizedBox(height: screenWidth * 0.08),

              /// Buttons (side by side responsive)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("cancel".tr,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserFilterBloc>().add(
                              ApplyFiltersEvent(
                                minPrice: startPrice,
                                maxPrice: endPrice,
                                minRate: selectedRate?.toDouble(),
                                role: selectedRole,
                                track: selectedTrack,
                              ),
                            );
                        Navigator.pop(context, activeFiltersCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "apply".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChoiceChips<T>({
    required BuildContext context,
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onSelected,
    bool showIcon = false,
    IconData? icon,
    String Function(T)? labelBuilder,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = AppPalette.primary;
    final inactiveColor = Theme.of(context).cardColor;
    final textActive = Colors.white;
    final textInactive =
        isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final selected = selectedItem == item;
        final label = labelBuilder?.call(item) ?? "$item";

        return ChoiceChip(
          label: showIcon
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null)
                      Icon(icon,
                          size: 18,
                          color: selected ? textActive : textInactive),
                    Text("  $label",
                        style: TextStyle(
                            color: selected ? textActive : textInactive)),
                  ],
                )
              : Text(label,
                  style:
                      TextStyle(color: selected ? textActive : textInactive)),
          selected: selected,
          backgroundColor: inactiveColor,
          selectedColor: activeColor,
          checkmarkColor: textActive,
          onSelected: (_) => onSelected(selected ? null : item),
        );
      }).toList(),
    );
  }
}
