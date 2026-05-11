import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:get/get.dart';

import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';
import '../../../../shared/common_ui/base_screen.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';
import '../models/user_rank.dart';
import '../widgets/recommended_card.dart';

class RecommendedViewAll extends StatefulWidget {
  final String track;

  const RecommendedViewAll({super.key, required this.track});
=======
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/recommended_card.dart';

class RecommendedViewAll extends StatefulWidget {
  const RecommendedViewAll({super.key});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  State<RecommendedViewAll> createState() => _RecommendedViewAllState();
}

class _RecommendedViewAllState extends State<RecommendedViewAll> {
<<<<<<< HEAD
=======
  int? selectedIndex = 1;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
<<<<<<< HEAD
    final bloc = context.read<UserFilterBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoadingMore &&
        !state.isLastPage) {
      bloc.add(
        LoadMoreUsersEvent(
          page: bloc.currentPage + 1,
          track: state.selectedTrack,
        ),
      );
=======
    final cubit = context.read<UsersCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
<<<<<<< HEAD
    final padding = 16.0;

    /// 🎯 Responsive Aspect Ratio (موبايل فقط)
    double aspectRatio;
    if (screenWidth < 360) {
      aspectRatio = 0.6;
    } else if (screenWidth < 400) {
      aspectRatio = 0.65;
    } else if (screenWidth < 450) {
      aspectRatio = 0.7;
    } else {
      aspectRatio = 0.75;
    }

    return BlocProvider(
      create: (_) => UserFilterBloc(
        userRepository: sl(),
        allUsers: [],
      )..add(
          ApplyFiltersEvent(track: widget.track),
        ),
      child: BaseScreen(
        title: "Recommend for You",
        child: BlocBuilder<UserFilterBloc, UserFilterState>(
          builder: (context, state) {
            /// 🔄 Loading أول مرة
            if (state.isLoading && state.filteredList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.filteredList.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            /// 🔥 نفس ترتيب السكشن (IMPORTANT)
            final rankedList = rankRecommendedUsers(
              state.filteredList,
              state.selectedTrack,
            );
=======

    double radius = 32;
    double padding = 16;

    if (screenWidth >= 800) {
      radius = 40;
      padding = 24;
    }

    return BaseScreen(
      title: "Recommend for You",
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersError) {
            return Center(child: Text(state.message));
          }

          if (state is UsersLoaded) {
            final usersList = state.users;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
<<<<<<< HEAD
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount:
                  state.isLastPage ? rankedList.length : rankedList.length + 1,
              itemBuilder: (context, index) {
                /// 🔄 Loading pagination
                if (index >= rankedList.length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppPalette.primary,
                    ),
                  );
                }

                final u = rankedList[index];

                return InkWell(
                  onTap: () {
                    Get.to(
                      ProfileMentor(
                        id: u.id,
                        name: u.name,
                        track: u.track.name,
                        rate: u.rate,
                        image: u.userImage.secureUrl,
                        bio: u.profile.bio,
                        skills: u.skills,
                        hoursAvailable: u.freeHours,
                        peopleHelped: u.helpTotalHours,
                        hourlyRate: u.hourlyPrice,
                        reviews: u.reviews,
                        role: u.role,
                      ),
                    );
                  },
                  child: RecommendedCard(
                    id: u.id,
                    image: u.userImage.secureUrl,
                    name: u.name,
                    track: u.track.name,
                    rating: u.rate,
                  ),
                );
              },
            );
          },
        ),
=======
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.55),
              itemCount:
                  state.isLastPage ? usersList.length : usersList.length + 1,
              itemBuilder: (context, index) {
                if (index >= usersList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppPalette.primary)),
                  );
                }

                final mentor = usersList[index];
                return RecommendedCard(
                  id: mentor.id,
                  image: mentor.userImage.secureUrl,
                  name: mentor.name,
                  track: mentor.track.name ?? "Mobile Development",
                  rating: mentor.rate,
                );
              },
            );
          }

          return const SizedBox();
        },
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      ),
    );
  }
}
