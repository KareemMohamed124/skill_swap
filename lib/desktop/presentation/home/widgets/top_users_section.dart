import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/top_user_card.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';

class TopUsersSectionDesktop extends StatelessWidget {
  final ScrollController controller;

  const TopUsersSectionDesktop({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true, topUsers: true),
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          final usersList = state is UsersLoaded ? state.users : [];
          final isLastPage = state is UsersLoaded ? state.isLastPage : false;

          return SizedBox(
            height: 150,
            child: GridView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: usersList.isNotEmpty
                  ? (isLastPage ? usersList.length : usersList.length + 1)
                  : 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                if (usersList.isEmpty) {
                  return const TopUserCard(isLoading: true);
                }

                if (index >= usersList.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final u = usersList[index];

                return InkWell(
                  onTap: () {
                    desktopKey.currentState?.openSidePage(
                      body: ProfileMentorDesktop(
                        id: u.id,
                        name: u.userName,
                        track: u.track.userName,
                        rate: u.rate,
                        image: u.userImage.secureUrl,
                        bio: u.profile.bio,
                        skills: u.skills,
                        hoursAvailable: u.freeHours,
                        peopleHelped: u.helpTotalHours,
                        hourlyRate: 0,
                      ),
                    );
                  },
                  child: TopUserCard(
                    id: u.id,
                    image: u.userImage.secureUrl,
                    name: u.userName,
                    track: u.track.userName,
                    hours: u.helpTotalHours,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
