import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_event.dart';
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_state.dart';
import '../../book_session/screens/profile_mentor.dart';
import '../widgets/filterSheet.dart';
import '../widgets/filter_button.dart';
import '../widgets/mentor_card.dart';
import '../widgets/sort_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearched = false;
  TextEditingController searchTextController = TextEditingController();
  int activeFiltersCount = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  padding: EdgeInsets.all(screenWidth * 0.04), // نسبية
                  child: Column(
                    children: [
                      SizedBox(height: screenWidth * 0.02),

                      /// Top Bar
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back,
                                size: isDesktop ? 28 : 24),
                            onPressed: () => Get.back(),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'search'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: isDesktop ? 24 : 20,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: isDesktop ? 48 : 32),
                        ],
                      ),

                      SizedBox(height: screenWidth * 0.02),

                      /// Search Field + Filter Icon
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: isDesktop ? 55 : 50,
                              child: TextField(
                                controller: searchTextController,
                                cursorColor:
                                    isDark ? Colors.white : Colors.black,
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
                                  prefixIcon: Icon(Icons.search,
                                      size: isDesktop ? 28 : 24),
                                  hintText: "search_placeholder".tr,
                                ),
                                onChanged: (searchValue) {
                                  context
                                      .read<MentorFilterBloc>()
                                      .add(SearchMentorEvent(searchValue));
                                  setState(() {
                                    isSearched = searchValue.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),

                          /// Filter Icon Button
                          SizedBox(
                            height: isDesktop ? 55 : 50,
                            width: isDesktop ? 55 : 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Theme.of(context).dividerColor),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.tune_outlined,
                                    color: isDark ? Colors.white : Colors.black,
                                    size: isDesktop ? 28 : 24),
                                onPressed: () async {
                                  final bloc = context.read<MentorFilterBloc>();
                                  final state = bloc.state;

                                  final activeFilters =
                                      await showModalSideSheet<int>(
                                    context: context,
                                    withCloseControll: false,
                                    barrierColor: const Color(0xFFD6D6D6)
                                        .withOpacity(0.3),
                                    width: isDesktop ? 500 : screenWidth * 0.85,
                                    body: BlocProvider.value(
                                      value: bloc,
                                      child: MentorFilterSheet(
                                        initialMinPrice: state.minPrice,
                                        initialMaxPrice: state.maxPrice,
                                        initialRate: state.selectedRate,
                                        initialStatus: state.selectedStatus,
                                        initialTrack: state.selectedTrack,
                                        initialSkill: state.enteredSkill,
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
                          ),
                        ],
                      ),

                      SizedBox(height: screenWidth * 0.02),

                      /// Sort + Filter Buttons
                      Row(
                        children: [
                          Expanded(child: SortButton()),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: FilterButton(
                              activeFilters: activeFiltersCount,
                              onPressed: () async {
                                final bloc = context.read<MentorFilterBloc>();
                                final state = bloc.state;

                                final activeFilters =
                                    await showModalSideSheet<int>(
                                  context: context,
                                  withCloseControll: false,
                                  barrierColor:
                                      const Color(0xFFD6D6D6).withOpacity(0.3),
                                  width: isDesktop ? 500 : screenWidth * 0.85,
                                  body: BlocProvider.value(
                                    value: bloc,
                                    child: MentorFilterSheet(
                                      initialMinPrice: state.minPrice,
                                      initialMaxPrice: state.maxPrice,
                                      initialRate: state.selectedRate,
                                      initialStatus: state.selectedStatus,
                                      initialTrack: state.selectedTrack,
                                      initialSkill: state.enteredSkill,
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

                      SizedBox(height: screenWidth * 0.015),

                      /// Mentor List
                      Expanded(
                        child: BlocBuilder<MentorFilterBloc, MentorFilterState>(
                          builder: (context, state) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.filteredList.length,
                              itemBuilder: (context, index) {
                                final mentor = state.filteredList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(ProfileMentor(
                                      id: mentor.id,
                                      name: mentor.name,
                                      track: mentor.track,
                                      rate: mentor.rate,
                                      image: mentor.image,
                                    ));
                                  },
                                  child: MentorCard(
                                    image: mentor.image,
                                    name: mentor.name,
                                    status: mentor.status,
                                    rate: mentor.rate,
                                    hours: mentor.hours,
                                    price: mentor.price,
                                    track: mentor.track,
                                    skills: mentor.skills,
                                    responseTime: mentor.responseTime,
                                  ),
                                );
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
