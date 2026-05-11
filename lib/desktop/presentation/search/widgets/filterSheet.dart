import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../main.dart';
import '../../../../mobile/presentation/search/widgets/price_filter_section.dart';
import '../../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/track/track_model.dart';

class MentorFilterPanel extends StatefulWidget {
=======
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/price_filter_section.dart';

import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';

class MentorFilterSheet extends StatefulWidget {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final double initialMinPrice;
  final double initialMaxPrice;
  final int? initialRate;
  final String? initialRole;
  final String? initialTrack;

<<<<<<< HEAD
  const MentorFilterPanel({
    super.key,
    this.initialMinPrice = 0,
    this.initialMaxPrice = 20,
    this.initialRate,
    this.initialRole,
    this.initialTrack,
  });

  @override
  State<MentorFilterPanel> createState() => _MentorFilterPanelState();
}

class _MentorFilterPanelState extends State<MentorFilterPanel> {
=======
  //final String? initialSkill;

  const MentorFilterSheet({
    super.key,
    this.initialMinPrice = 20,
    this.initialMaxPrice = 60,
    this.initialRate,
    this.initialRole,
    this.initialTrack,
    //this.initialSkill,
  });

  @override
  State<MentorFilterSheet> createState() => _MentorFilterSheetState();
}

class _MentorFilterSheetState extends State<MentorFilterSheet> {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  late double startPrice;
  late double endPrice;

  int? selectedRate;
  String? selectedRole;
<<<<<<< HEAD
  TrackModel? selectedTrack;

  void _restoreTrackIfNeeded(List<TrackModel> tracks) {
    if (selectedTrack == null && widget.initialTrack != null) {
      final match = tracks.where((e) => e.name == widget.initialTrack);
      if (match.isNotEmpty) {
        selectedTrack = match.first;
      }
    }
  }
=======
  String? selectedTrack;

  //String? enteredSkill;

  late TextEditingController skillController;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  int activeFiltersCount = 0;

  final List<String> roles = ["Mentor", "Normal"];
<<<<<<< HEAD

=======
  final List<String> tracks = ["Frontend", "Mobile", "AI", "Ui/Ux", "Backend"];
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final List<int> rates = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

    startPrice = widget.initialMinPrice;
    endPrice = widget.initialMaxPrice;

    selectedRate = widget.initialRate;
    selectedRole = widget.initialRole;

    context.read<TracksCubit>().fetchTracks();

    if (startPrice != 0 || endPrice != 20) activeFiltersCount++;
    if (selectedRate != null) activeFiltersCount++;
    if (selectedRole != null) activeFiltersCount++;
    if (selectedTrack != null) activeFiltersCount++;
=======
    startPrice = widget.initialMinPrice;
    endPrice = widget.initialMaxPrice;
    selectedRate = widget.initialRate;
    selectedRole = widget.initialRole;
    selectedTrack = widget.initialTrack;
    //enteredSkill = widget.initialSkill;

    //skillController = TextEditingController(text: enteredSkill ?? "");

    if (startPrice != 20 || endPrice != 60) activeFiltersCount++;
    if (selectedRate != null) activeFiltersCount++;
    if (selectedRole != null) activeFiltersCount++;
    if (selectedTrack != null) activeFiltersCount++;
    //if (enteredSkill != null && enteredSkill!.isNotEmpty) activeFiltersCount++;
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Filters",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),

              const SizedBox(height: 20),

              /// PRICE
              PriceFilterSection(
                min: 0,
                max: 20,
                onChanged: (start, end) {
                  setState(() {
                    if (startPrice == 0 &&
                        endPrice == 20 &&
                        (start != 0 || end != 20)) {
                      activeFiltersCount++;
                    }

=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    startPrice = start;
                    endPrice = end;
                  });
                },
              ),
<<<<<<< HEAD

              const SizedBox(height: 16),

              Text("role".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),

              /// ROLE
              buildChips<String>(
=======
              const SizedBox(height: 16),

              /// Role
              Text("role".tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              buildChoiceChips<String>(
                context: context,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                items: roles,
                selectedItem: selectedRole,
                onSelected: (value) {
                  setState(() {
<<<<<<< HEAD
                    if (selectedRole == null && value != null) {
                      activeFiltersCount++;
                    } else if (selectedRole != null && value == null) {
                      activeFiltersCount--;
                    }
=======
                    if (selectedRole == null && value != null)
                      activeFiltersCount++;
                    else if (selectedRole != null && value == null)
                      activeFiltersCount--;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    selectedRole = value;
                  });
                },
              ),
<<<<<<< HEAD

              const SizedBox(height: 16),

              /// Track
              Text("track".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),

              BlocBuilder<TracksCubit, TracksState>(
                builder: (context, state) {
                  if (state is TracksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TracksError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is TracksLoaded) {
                    final tracks = state.tracks;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;

                      setState(() {
                        _restoreTrackIfNeeded(tracks);
                      });
                    });

                    return buildChips<TrackModel>(
                      items: tracks,
                      selectedItem: selectedTrack,
                      labelBuilder: (item) => item.name,
                      onSelected: (value) {
                        setState(() {
                          selectedTrack = value;
                        });
                      },
                    );
                  }

                  return const SizedBox();
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                },
              ),
              const SizedBox(height: 16),

<<<<<<< HEAD
              /// Rating
              Text("rating".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),

              buildChips<int>(
                items: rates,
                selectedItem: selectedRate,
                showIcon: true,
                icon: Icons.star,
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
              ),

              const SizedBox(height: 30),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        desktopKey.currentState?.goBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme
                            .of(context)
                            .cardColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
=======
              // /// Skill
              // Text("skill".tr, style: Theme.of(context).textTheme.titleMedium),
              // const SizedBox(height: 8),
              // ConstrainedBox(
              //   constraints: const BoxConstraints(minHeight: 50),
              //   child: TextField(
              //     controller: skillController,
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Theme.of(context).cardColor,
              //       hintText: "enter_skill_name".tr,
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide:
              //             BorderSide(color: Theme.of(context).dividerColor),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onChanged: (value) {
              //       setState(() {
              //         final trimmed = value.trim();
              //         if (enteredSkill == null && trimmed.isNotEmpty)
              //           activeFiltersCount++;
              //         else if (enteredSkill != null && trimmed.isEmpty)
              //           activeFiltersCount--;
              //         enteredSkill = trimmed.isEmpty ? null : trimmed;
              //       });
              //     },
              //   ),
              // ),
              // const SizedBox(height: 16),

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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("cancel".tr,
<<<<<<< HEAD
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserFilterBloc>().add(
                          ApplyFiltersEvent(
                            minPrice: startPrice,
                            maxPrice: endPrice,
                            minRate: selectedRate?.toDouble(),
                            role: selectedRole,
                            track: selectedTrack?.name,
                          ),
                        );

                        int newCount = 0;
                        if (startPrice != 0 || endPrice != 20) newCount++;
                        if (selectedRate != null) newCount++;
                        if (selectedRole != null) newCount++;
                        if (selectedTrack != null) newCount++;
                        desktopKey.currentState?.goBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
=======
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
                                //skill: enteredSkill,
                              ),
                            );
                        Navigator.pop(context, activeFiltersCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenWidth * 0.03),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "apply".tr,
<<<<<<< HEAD
                        style: TextStyle(
=======
                        style: const TextStyle(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
<<<<<<< HEAD
              )
=======
              ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget buildChips<T>({
=======
  Widget buildChoiceChips<T>({
    required BuildContext context,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onSelected,
    bool showIcon = false,
    IconData? icon,
<<<<<<< HEAD
    String Function(T)? labelBuilder,
  }) {
=======
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppPalette.primary;
    final inactiveColor = Theme.of(context).cardColor;
    final textActive = Colors.white;
    final textInactive =
        isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary;

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final selected = selectedItem == item;
<<<<<<< HEAD
        final label = labelBuilder?.call(item) ?? "$item";

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon && icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : Colors.black,
                ),
              if (showIcon) const SizedBox(width: 4),
              Text(label),
            ],
          ),
          selected: selected,
          selectedColor: AppPalette.primary,
=======

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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          onSelected: (_) => onSelected(selected ? null : item),
        );
      }).toList(),
    );
  }
}
