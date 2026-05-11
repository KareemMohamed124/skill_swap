import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/search/widgets/price_filter_section.dart';

<<<<<<< HEAD
import '../../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/track/track_model.dart';
=======
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class MentorFilterSheet extends StatefulWidget {
  final double initialMinPrice;
  final double initialMaxPrice;
  final int? initialRate;
  final String? initialRole;
  final String? initialTrack;

  const MentorFilterSheet({
    super.key,
<<<<<<< HEAD
    this.initialMinPrice = 0,
    this.initialMaxPrice = 20,
=======
    this.initialMinPrice = 20,
    this.initialMaxPrice = 60,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
  TrackModel? selectedTrack;

  final List<String> roles = ["Mentor", "Normal"];
=======
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
  }

  void _restoreTrackIfNeeded(List<TrackModel> tracks) {
    if (selectedTrack == null && widget.initialTrack != null) {
      final match = tracks.where((e) => e.name == widget.initialTrack);
      if (match.isNotEmpty) {
        selectedTrack = match.first;
      }
    }
  }

  int get activeFiltersCount {
    int count = 0;

    if (startPrice != 0 || endPrice != 20) count++;
    if (selectedRate != null) count++;
    if (selectedRole != null) count++;
    if (selectedTrack != null) count++;

    return count;
=======
    startPrice = widget.initialMinPrice;
    endPrice = widget.initialMaxPrice;
    selectedRate = widget.initialRate;
    selectedRole = widget.initialRole;
    selectedTrack = widget.initialTrack;

    if (startPrice != 20 || endPrice != 60) activeFiltersCount++;
    if (selectedRate != null) activeFiltersCount++;
    if (selectedRole != null) activeFiltersCount++;
    if (selectedTrack != null) activeFiltersCount++;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
=======
    final screenWidth = MediaQuery.of(context).size.width;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
<<<<<<< HEAD
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
=======
          color: Theme.of(context).scaffoldBackgroundColor,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
<<<<<<< HEAD
              Text(
                "filters".tr,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium,
              ),

              SizedBox(height: screenWidth * 0.02),
              const Divider(),
              SizedBox(height: screenWidth * 0.02),

              /// PRICE
              PriceFilterSection(
                min: 0,
                max: 20,
                onChanged: (start, end) {
                  setState(() {
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    startPrice = start;
                    endPrice = end;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.04),

<<<<<<< HEAD
              /// ROLE
              Text("role".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),

              SizedBox(height: screenWidth * 0.02),

=======
              /// Role
              Text("role".tr, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: screenWidth * 0.02),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              buildChoiceChips<String>(
                context: context,
                items: roles,
                selectedItem: selectedRole,
                onSelected: (value) {
                  setState(() {
<<<<<<< HEAD
=======
                    if (selectedRole == null && value != null) {
                      activeFiltersCount++;
                    } else if (selectedRole != null && value == null) {
                      activeFiltersCount--;
                    }
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    selectedRole = value;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.04),

<<<<<<< HEAD
              /// TRACK
              Text("track".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),

              SizedBox(height: screenWidth * 0.02),

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

                    return buildChoiceChips<TrackModel>(
                      context: context,
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
                },
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),

              SizedBox(height: screenWidth * 0.04),

<<<<<<< HEAD
              /// RATING
              Text("rating".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),

              SizedBox(height: screenWidth * 0.02),

=======
              /// Rating
              Text("rating".tr, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: screenWidth * 0.02),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              buildChoiceChips<int>(
                context: context,
                items: rates,
                selectedItem: selectedRate,
<<<<<<< HEAD
                showIcon: true,
                icon: Icons.star,
                onSelected: (value) {
                  setState(() {
                    selectedRate = value;
                  });
                },
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),

              SizedBox(height: screenWidth * 0.08),

<<<<<<< HEAD
              /// BUTTONS
=======
              /// Buttons (side by side responsive)
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                        backgroundColor: Theme
                            .of(context)
                            .cardColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
=======
                        backgroundColor: Theme.of(context).cardColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
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
=======
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  SizedBox(width: 12),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserFilterBloc>().add(
<<<<<<< HEAD
                          ApplyFiltersEvent(
                            minPrice: startPrice,
                            maxPrice: endPrice,
                            minRate: selectedRate?.toDouble(),
                            role: selectedRole,
                            track: selectedTrack?.name,
                          ),
                        );

=======
                              ApplyFiltersEvent(
                                minPrice: startPrice,
                                maxPrice: endPrice,
                                minRate: selectedRate?.toDouble(),
                                role: selectedRole,
                                track: selectedTrack,
                              ),
                            );
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        Navigator.pop(context, activeFiltersCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
<<<<<<< HEAD
                        padding: const EdgeInsets.symmetric(vertical: 16),
=======
                        padding: EdgeInsets.symmetric(vertical: 16),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
<<<<<<< HEAD
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
=======
                      child: Text(
                        "apply".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final activeColor = AppPalette.primary;
    final inactiveColor = Theme
        .of(context)
        .cardColor;
    final textActive = Colors.white;
    final textInactive =
    isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary;
=======
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
<<<<<<< HEAD
        final label = labelBuilder?.call(item) ?? "$item";
        final selectedLabel = selectedItem != null
            ? (labelBuilder?.call(selectedItem) ?? "$selectedItem")
            : null;
        final selected = label == selectedLabel;
=======
        final selected = selectedItem == item;
        final label = labelBuilder?.call(item) ?? "$item";
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

        return ChoiceChip(
          label: showIcon
              ? Row(
<<<<<<< HEAD
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
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
