import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/top_user_card.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';

class TopUsersSectionDesktop extends StatelessWidget {
  const TopUsersSectionDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true, topUsers: true),
      child: const _TopUsersList(),
    );
  }
}

class _TopUsersList extends StatefulWidget {
  const _TopUsersList({super.key});

  @override
  State<_TopUsersList> createState() => _TopUsersListState();
}

class _TopUsersListState extends State<_TopUsersList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    final cubit = context.read<UsersCubit>();
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 150 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  double _getCardWidth(double screenWidth) {
    if (screenWidth > 1600) return 200;
    if (screenWidth > 1200) return 180;
    if (screenWidth > 900) return 160;
    return 140;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = _getCardWidth(screenWidth);

    return SizedBox(
      height: 180,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, __) =>
                  TopUserCard(isLoading: true, widthCard: cardWidth),
            );
          }

          if (state is UsersLoaded) {
            return ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.isLastPage
                  ? state.users.length
                  : state.users.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                if (index < state.users.length) {
                  final u = state.users[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      desktopKey.currentState?.openSidePage(
                        body: ProfileMentorDesktop(
                          id: u.id,
                          name: u.name,
                          track: u.track.name,
                          rate: u.rate,
                          role: u.role,
                          image: u.userImage.secureUrl,
                          bio: u.profile.bio,
                          skills: u.skills,
                          hoursAvailable: u.freeHours,
                          peopleHelped: u.helpTotalHours,
                          hourlyRate: 0,
                          reviews: u.reviews,
                        ),
                      );
                    },
                    child: TopUserCard(
                      widthCard: cardWidth,
                      id: u.id,
                      image: u.userImage.secureUrl,
                      name: u.name,
                      track: u.track.name.isEmpty
                          ? "Mobile Development"
                          : u.track.name,
                      hours: u.helpTotalHours,
                    ),
                  );
                } else {
                  return SizedBox(
                    width: cardWidth,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppPalette.primary,
                      ),
                    ),
                  );
                }
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
