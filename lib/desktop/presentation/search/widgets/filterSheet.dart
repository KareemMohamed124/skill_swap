import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/price_filter_section.dart';

import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';

class MentorFilterSheet extends StatefulWidget {
  final double initialMinPrice;
  final double initialMaxPrice;
  final int? initialRate;
  final String? initialRole;
  final String? initialTrack;
  final String? initialSkill;

  const MentorFilterSheet({
    super.key,
    this.initialMinPrice = 20,
    this.initialMaxPrice = 60,
    this.initialRate,
    this.initialRole,
    this.initialTrack,
    this.initialSkill,
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
  String? enteredSkill;

  late TextEditingController skillController;

  int activeFiltersCount = 0;

  final List<String> roles = ["Mentor", "Normal"];
  final List<String> tracks = ["Frontend", "Mobile", "AI", "Ui/Ux", "Backend"];
  final List<int> rates = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    startPrice = widget.initialMinPrice;
    endPrice = widget.initialMaxPrice;
    selectedRate = widget.initialRate;
    selectedRole = widget.initialRole;
    selectedTrack = widget.initialTrack;
    enteredSkill = widget.initialSkill;

    skillController = TextEditingController(text: enteredSkill ?? "");

    if (startPrice != 20 || endPrice != 60) activeFiltersCount++;
    if (selectedRate != null) activeFiltersCount++;
    if (selectedRole != null) activeFiltersCount++;
    if (selectedTrack != null) activeFiltersCount++;
    if (enteredSkill != null && enteredSkill!.isNotEmpty) activeFiltersCount++;
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final buttonWidth = isDesktop ? screenWidth * 0.2 : screenWidth * 0.4;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Text(
                "filters".tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

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
              const SizedBox(height: 16),

              /// Role
              Text("role".tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              buildChoiceChips<String>(
                context: context,
                items: roles,
                selectedItem: selectedRole,
                onSelected: (value) {
                  setState(() {
                    if (selectedRole == null && value != null)
                      activeFiltersCount++;
                    else if (selectedRole != null && value == null)
                      activeFiltersCount--;
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Track
              Text("track".tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              buildChoiceChips<String>(
                context: context,
                items: tracks,
                selectedItem: selectedTrack,
                onSelected: (value) {
                  setState(() {
                    if (selectedTrack == null && value != null)
                      activeFiltersCount++;
                    else if (selectedTrack != null && value == null)
                      activeFiltersCount--;
                    selectedTrack = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Skill
              Text("skill".tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50),
                child: TextField(
                  controller: skillController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    hintText: "enter_skill_name".tr,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      final trimmed = value.trim();
                      if (enteredSkill == null && trimmed.isNotEmpty)
                        activeFiltersCount++;
                      else if (enteredSkill != null && trimmed.isEmpty)
                        activeFiltersCount--;
                      enteredSkill = trimmed.isEmpty ? null : trimmed;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// Rating
              Text("rating".tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              buildChoiceChips<int>(
                context: context,
                items: rates,
                selectedItem: selectedRate,
                onSelected: (value) {
                  setState(() {
                    if (selectedRate == null && value != null)
                      activeFiltersCount++;
                    else if (selectedRate != null && value == null)
                      activeFiltersCount--;
                    selectedRate = value;
                  });
                },
                showIcon: true,
                icon: Icons.star,
              ),
              const SizedBox(height: 32),

              /// Buttons
              Wrap(
                spacing: screenWidth * 0.03,
                runSpacing: screenWidth * 0.03,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenWidth * 0.03),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("cancel".tr,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserFilterBloc>().add(
                              ApplyFiltersEvent(
                                minPrice: startPrice,
                                maxPrice: endPrice,
                                minRate: selectedRate?.toDouble(),
                                role: selectedRole,
                                track: selectedTrack,
                                skill: enteredSkill,
                              ),
                            );
                        Navigator.pop(context, activeFiltersCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenWidth * 0.03),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "apply".tr,
                        style: const TextStyle(
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

        return ChoiceChip(
          label: showIcon
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null)
                      Icon(icon,
                          size: 18,
                          color: selected ? textActive : textInactive),
                    Text("  $item",
                        style: TextStyle(
                            color: selected ? textActive : textInactive)),
                  ],
                )
              : Text("$item",
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
