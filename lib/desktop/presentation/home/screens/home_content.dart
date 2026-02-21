import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/profile_mentor.dart';
import 'package:skill_swap/desktop/presentation/home/pages/recommended_view_all.dart';
import 'package:skill_swap/desktop/presentation/home/pages/top_users_view_all.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/next_session_card.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/recommended_card.dart'
    show RecommendedCard;
import 'package:skill_swap/desktop/presentation/home/widgets/section_header.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/top_user_card.dart';
import 'package:skill_swap/main.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../mobile/presentation/home/pages/next_session_view_all.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/constants/strings.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildAvatar(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.person, size: 48, color: Colors.white);
    }

    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.person, size: 48, color: Colors.white),
      );
    }

    return const Icon(Icons.person, size: 48, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<MyProfileCubit, MyProfileState>(
                  builder: (context, state) {
                    String name = "User";
                    String avatarPath = '';

                    if (state is MyProfileLoaded) {
                      name = state.profile.name ?? name;
                      avatarPath = state.profile.userImage?.secureUrl ?? '';
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                          BorderSide(color: Colors.grey.shade800, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            child: ClipOval(
                              child: _buildAvatar(avatarPath),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, $name',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'keep_learning'.tr,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  sectionTitle: 'top_users'.tr,
                  onTop: () =>
                      desktopKey.currentState?.openSidePage(
                        body: BlocProvider.value(
                          value: context.read<UsersCubit>(),
                          child: const TopUsersViewAll(),
                        ),
                      ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    final usersList = state is UsersLoaded ? state.users : [];

                    return SizedBox(
                      height: 150,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: usersList.isNotEmpty ? usersList.length : 5,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          if (usersList.isEmpty) {
                            return const TopUserCard(isLoading: true);
                          }

                          final u = usersList[index];

                          return InkWell(
                            onTap: () {
                              desktopKey.currentState?.openSidePage(
                                body: ProfileMentor(
                                  id: u.id,
                                  name: u.name,
                                  track: "Flutter",
                                  rate: u.rate,
                                  image: u.userImage.secureUrl,
                                ),
                              );
                            },
                            child: TopUserCard(
                              id: u.id,
                              image: u.userImage.secureUrl,
                              name: u.name,
                              track: "Flutter",
                              hours: "44",
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                SectionHeader(
                  sectionTitle: 'your_next_session'.tr,
                  onTop: () =>
                      desktopKey.currentState?.openSidePage(
                        body: const NextSessionViewAll(),
                      ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.nextSessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final s = AppData.nextSessions[i];
                    return NextSessionCard(
                      name: s.name,
                      duration: s.duration,
                      dateTime: s.dateTime,
                      startsIn: s.startsIn,
                      isMentor: s.isMentor,
                    );
                  },
                ),
                const SizedBox(height: 40),
                SectionHeader(
                  sectionTitle: 'recommended_for_you'.tr,
                  onTop: () =>
                      desktopKey.currentState?.openSidePage(
                        body: BlocProvider.value(
                          value: context.read<UsersCubit>(),
                          child: const RecommendedViewAll(),
                        ),
                      ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    final usersList = state is UsersLoaded ? state.users : [];

                    return SizedBox(
                      height: 170,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: usersList.isNotEmpty ? usersList.length : 5,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          if (usersList.isEmpty) {
                            return const RecommendedCard(isLoading: true);
                          }

                          final u = usersList[index];

                          return InkWell(
                            onTap: () {
                              desktopKey.currentState?.openSidePage(
                                body: ProfileMentor(
                                  id: u.id,
                                  name: u.name,
                                  track: "Flutter",
                                  rate: u.rate,
                                  image: u.userImage.secureUrl,
                                ),
                              );
                            },
                            child: RecommendedCard(
                              id: u.id,
                              image: u.userImage.secureUrl,
                              name: u.name,
                              track: "Flutter",
                              rating: 4,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
