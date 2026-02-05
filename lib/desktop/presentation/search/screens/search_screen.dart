import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/book_session.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/profile_mentor.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filterSheet.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filter_button.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/mentor_card.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/sort_button.dart';
import '../../../../main.dart';
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_event.dart';
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_state.dart';


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
                      Expanded(
                        child: SizedBox(
                          height: 50,
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
                              prefixIcon: const Icon(Icons.search),
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
                                final bloc =
                                context.read<MentorFilterBloc>();
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

                      const SizedBox(height: 8),

                      /// Mentor List
                      Expanded(
                        child: BlocBuilder<MentorFilterBloc,
                            MentorFilterState>(
                          builder: (context, state) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.filteredList.length,
                              itemBuilder: (context, index) {
                                final mentor = state.filteredList[index];
                                return InkWell(
                                onTap: () {
    desktopKey.currentState?.openSidePage(
    body: ProfileMentor(
    id: mentor.id,
    name: mentor.name,
    track: mentor.track,
    rate: mentor.rate,
    image: mentor.image,
    ),
    rightPanel: BookSession()
    );
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