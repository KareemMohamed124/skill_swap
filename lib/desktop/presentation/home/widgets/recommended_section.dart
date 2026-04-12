import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/recommended_card.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';

class RecommendedSectionDesktop extends StatelessWidget {
  final ScrollController controller;

  const RecommendedSectionDesktop({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, profileState) {
        if (profileState is! MyProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final track = profileState.profile.track.name ?? '';

        return BlocProvider(
          create: (_) => UserFilterBloc(
            userRepository: sl(),
            allUsers: [],
          )..add(ApplyFiltersEvent(track: track)),
          child: BlocBuilder<UserFilterBloc, UserFilterState>(
            builder: (context, state) {
              return SizedBox(
                height: 170,
                child: GridView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.isLastPage
                      ? state.filteredList.length
                      : state.filteredList.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index < state.filteredList.length) {
                      final u = state.filteredList[index];

                      return InkWell(
                          onTap: () {
                            desktopKey.currentState?.openSidePage(
                              body: ProfileMentorDesktop(
                                id: u.id,
                                name: u.name,
                                track: u.track.name,
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
                          child: RecommendedCard(
                            id: u.id,
                            image: u.userImage.secureUrl,
                            name: u.name,
                            track: u.track.name,
                            rating: u.rate,
                          ));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
