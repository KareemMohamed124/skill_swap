import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:skill_swap/bloc/mentor_filter_bloc/mentor_filter_event.dart';
import 'package:skill_swap/constants/colors.dart';
import '../../../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../bloc/mentor_filter_bloc/mentor_filter_state.dart';
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
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: searchTextController,
                      cursorColor: AppColor.mainColor,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.mainColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.mainColor.withValues(alpha: 0.8),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search by skill or mentor name...",
                      ),
                      onChanged: (searchValue) {
                        context.read<MentorFilterBloc>().add(
                          SearchMentorEvent(searchValue),
                        );
                        setState(() {
                          isSearched = searchValue.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Container(
                  height: 50,

                  width: 50,

                  decoration: BoxDecoration(
                    // color: AppColor.grayColor,
                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(color: AppColor.mainColor),
                  ),

                  child: IconButton(
                    icon: Icon(Icons.tune_outlined, color: AppColor.mainColor),
                    onPressed: () async {
                      final bloc = context.read<MentorFilterBloc>();
                      final activeFilters = await showModalSideSheet<int>(
                        context: context,
                        withCloseControll: false,
                        barrierColor: AppColor.grayColor.withValues(alpha: 0.3),
                        width: MediaQuery.of(context).size.width * 0.8,
                        body: BlocProvider.value(
                          value: bloc,
                          child: const MentorFilterSheet(),
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

            const SizedBox(height: 16),

            /// Sort + Filter buttons
            Row(
              children: [
                const Expanded(child: SortButton()),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterButton(activeFilters: activeFiltersCount),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<MentorFilterBloc, MentorFilterState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.filteredList.length,
                    itemBuilder: (context, index) {
                      final mentor = state.filteredList[index];
                      return InkWell(
                        onTap: () {
                          Get.to(
                            ProfileMentor(
                              name: mentor.name,
                              track: mentor.track,
                              rate: mentor.rate,
                              image: mentor.image,
                            ),
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
    );
  }
}
