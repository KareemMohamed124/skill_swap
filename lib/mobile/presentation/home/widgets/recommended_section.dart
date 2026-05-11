import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_event.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_state.dart';

import '../../../../mobile/presentation/home/widgets/recommended_card.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';
import '../models/user_rank.dart';
import '../pages/recommended_view_all.dart';
import '../widgets/section_header.dart';
=======
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../mobile/presentation/home/widgets/recommended_card.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, profileState) {
        if (profileState is! MyProfileLoaded) {
          return const SizedBox();
        }

        final currentTrack = profileState.profile.track.name ?? '';

        return BlocProvider(
          create: (_) => UserFilterBloc(
            userRepository: sl(),
            allUsers: [],
          )..add(
              ApplyFiltersEvent(
                track: currentTrack,
              ),
            ),

          /// 🔥 هنا بقى بنحط الهيدر + الليست
          child: BlocBuilder<UserFilterBloc, UserFilterState>(
            builder: (context, state) {
              final rankedList = rankRecommendedUsers(
                state.filteredList,
                state.selectedTrack,
              );

              /// ❌ لو مفيش داتا → اخفي السكشن كله
              if (!state.isLoading && rankedList.isEmpty) {
                return const SizedBox();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 HEADER
                  SectionHeader(
                    sectionTitle: 'recommended_for_you'.tr,
                    onTop: () {
                      Get.to(
                        RecommendedViewAll(track: currentTrack),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  /// 🔥 LIST (زي ما هي)
                  const _RecommendedList(),

                  SizedBox(height: screenHeight * 0.01),
                ],
              );
            },
          ),
        );
      },
=======
    return BlocProvider(
      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true),
      child: const _RecommendedList(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );
  }
}

class _RecommendedList extends StatefulWidget {
  const _RecommendedList({super.key});

  @override
  State<_RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<_RecommendedList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
<<<<<<< HEAD
    final bloc = context.read<UserFilterBloc>();
    final state = bloc.state;

    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 150 &&
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
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 150 &&
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
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.22,
<<<<<<< HEAD
      child: BlocBuilder<UserFilterBloc, UserFilterState>(
        builder: (context, state) {
          final rankedList = rankRecommendedUsers(
            state.filteredList,
            state.selectedTrack,
          );

          /// 🔄 Loading أول مرة
          if (state.isLoading && state.filteredList.isEmpty) {
=======
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => const RecommendedCard(isLoading: true),
            );
          }

<<<<<<< HEAD
          return ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount:
                state.isLastPage ? rankedList.length : rankedList.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index < rankedList.length) {
                final u = rankedList[index];

                return InkWell(
                  onTap: () {
                    Get.to(
                      ProfileMentor(
=======
          if (state is UsersLoaded) {
            return ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: state.isLastPage
                  ? state.users.length
                  : state.users.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index < state.users.length) {
                  final u = state.users[index];
                  return InkWell(
                    onTap: () {
                      Get.to(ProfileMentor(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        id: u.id,
                        name: u.name,
                        track: u.track.name,
                        rate: u.rate,
                        image: u.userImage.secureUrl,
                        bio: u.profile.bio,
<<<<<<< HEAD
                        role: u.role,
                        skills: u.skills,
                        hoursAvailable: u.freeHours,
                        peopleHelped: u.helpTotalHours,
                        hourlyRate: u.hourlyPrice,
                        reviews: u.reviews,
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
              } else {
                /// 🔄 Loading pagination
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppPalette.primary,
                    ),
                  ),
                );
              }
            },
          );
=======
                        skills: u.skills,
                        hoursAvailable: u.freeHours,
                        peopleHelped: u.helpTotalHours,
                        hourlyRate: 0,
                      ));
                    },
                    child: RecommendedCard(
                      id: u.id,
                      image: u.userImage.secureUrl,
                      name: u.name,
                      track: u.track.name,
                      rating: u.rate,
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: AppPalette.primary,
                    )),
                  );
                }
              },
            );
          }

          return const SizedBox();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        },
      ),
    );
  }
}
