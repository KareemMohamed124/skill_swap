import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_event.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_state.dart';

import '../../../../mobile/presentation/home/widgets/recommended_card.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, profileState) {
        if (profileState is! MyProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
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
          child: const _RecommendedList(),
        );
      },
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
      child: BlocBuilder<UserFilterBloc, UserFilterState>(
        builder: (context, state) {
          // loading skeleton
          if (state.isLoading && state.filteredList.isEmpty) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => const RecommendedCard(isLoading: true),
            );
          }

          return ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: state.isLastPage
                ? state.filteredList.length
                : state.filteredList.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index < state.filteredList.length) {
                final u = state.filteredList[index];

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
                        role: u.role,
                        skills: u.skills,
                        hoursAvailable: u.freeHours,
                        peopleHelped: u.helpTotalHours,
                        hourlyRate: 0,
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
        },
      ),
    );
  }
}
