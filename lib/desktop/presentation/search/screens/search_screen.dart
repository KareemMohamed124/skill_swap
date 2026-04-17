import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/profile_mentor.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filterSheet.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filter_button.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/mentor_card.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/sort_button.dart';

import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearched = false;
  TextEditingController searchTextController = TextEditingController();
  int activeFiltersCount = 0;
  Timer? _debounce;

  @override
  void dispose() {
    searchTextController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;
            final contentWidth = isDesktop ? 700.0 : double.infinity;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      /// Top Bar
                      Center(
                        child: Text(
                          'search'.tr,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Search Field + Filter Icon
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: searchTextController,
                          cursorColor: isDark ? Colors.white : Colors.black,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            hintText: "search_placeholder".tr,
                          ),
                          onChanged: (searchValue) {
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();
                            _debounce =
                                Timer(const Duration(milliseconds: 700), () {
                              context
                                  .read<UserFilterBloc>()
                                  .add(SearchUserEvent(searchValue));
                              setState(() {
                                isSearched = searchValue.isNotEmpty;
                              });
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Sort + Filter Buttons
                      Row(
                        children: [
                          const Expanded(child: SortButton()),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilterButton(
                              activeFilters: activeFiltersCount,
                              onPressed: () async {
                                final bloc = context.read<UserFilterBloc>();
                                final state = bloc.state;

                                final activeFilters =
                                    await showModalSideSheet<int>(
                                  context: context,
                                  withCloseControll: false,
                                  barrierColor: const Color(0xFFD6D6D6)
                                      .withValues(alpha: 0.3),
                                  width: isDesktop
                                      ? 500
                                      : MediaQuery.of(context).size.width *
                                          0.85,
                                  body: BlocProvider.value(
                                    value: bloc,
                                    child: MentorFilterSheet(
                                      initialMinPrice: state.minPrice,
                                      initialMaxPrice: state.maxPrice,
                                      initialRate: state.selectedRate,
                                      initialRole: state.selectedRole,
                                      initialTrack: state.selectedTrack,
                                      //initialSkill: state.enteredSkill,
                                    ),
                                  ),
                                );

                                if (activeFilters != null) {
                                  setState(() {
                                    activeFiltersCount = activeFilters;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// Mentor List
                      Expanded(
                        child: BlocBuilder<UserFilterBloc, UserFilterState>(
                          builder: (context, state) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.filteredList.length + 1,
                              itemBuilder: (context, index) {
                                if (index < state.filteredList.length) {
                                  final user = state.filteredList[index];
                                  return InkWell(
                                    onTap: () {
                                      Get.to(ProfileMentorDesktop(
                                        id: user.id,
                                        name: user.name,
                                        track: user.track.name,
                                        rate: user.rate,
                                        image: user.userImage.secureUrl,
                                        bio: user.profile.bio,
                                        skills: user.skills,
                                        hoursAvailable: user.freeHours,
                                        peopleHelped: user.helpTotalHours,
                                        hourlyRate: 0,
                                        reviews: user.reviews,
                                      ));
                                    },
                                    child: MentorCard(
                                      image: user.userImage.secureUrl,
                                      name: user.name,
                                      role: user.role,
                                      rate: user.rate,
                                      hours: 5,
                                      price: 0,
                                      track: user.track.name,
                                      skills: user.skills,
                                      responseTime: "9",
                                    ),
                                  );
                                } else {
                                  if (!state.isLastPage &&
                                      !state.isLoadingMore) {
                                    final bloc = context.read<UserFilterBloc>();
                                    bloc.add(LoadMoreUsersEvent(
                                      page: bloc.currentPage + 1,
                                      limit: bloc.limit,
                                      query:
                                          searchTextController.text.isNotEmpty
                                              ? searchTextController.text
                                              : null,
                                      minPrice: state.minPrice?.toDouble(),
                                      maxPrice: state.maxPrice?.toDouble(),
                                      minRate: state.selectedRate?.toDouble(),
                                      role: state.selectedRole,
                                      track: state.selectedTrack,
                                    ));
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
