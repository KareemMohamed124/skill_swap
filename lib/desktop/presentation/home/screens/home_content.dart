import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:skill_swap/desktop/presentation/home/pages/top_users_view_all.dart';
import 'package:skill_swap/main.dart';

import '../../../../desktop/presentation/game_part/game_section.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/helper/home_controller.dart';
import '../widgets/next_session_section.dart';
import '../widgets/recommended_section.dart';
import '../widgets/section_header.dart';
import '../widgets/top_users_section.dart';
=======
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
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/dependency_injection/injection.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _topUsersScrollController = ScrollController();
  final ScrollController _recommendedScrollController = ScrollController();

<<<<<<< HEAD
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    _topUsersScrollController.addListener(_topUsersScrollListener);
    _recommendedScrollController.addListener(_recommendedScrollListener);

    context.read<MyProfileCubit>().fetchMyProfile();
    context.read<GetBookingsCubit>().fetchTodayNextSessions();
=======
  @override
  void initState() {
    super.initState();
    _topUsersScrollController.addListener(_topUsersScrollListener);
    _recommendedScrollController.addListener(_recommendedScrollListener);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  void _topUsersScrollListener() {
    _handleScroll(_topUsersScrollController);
  }

  void _recommendedScrollListener() {
    _handleScroll(_recommendedScrollController);
  }

  void _handleScroll(ScrollController controller) {
    final cubit = context.read<UsersCubit>();
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    if (controller.position.pixels >=
            controller.position.maxScrollExtent - 150 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _topUsersScrollController.removeListener(_topUsersScrollListener);
    _topUsersScrollController.dispose();
<<<<<<< HEAD

    _recommendedScrollController.removeListener(_recommendedScrollListener);
    _recommendedScrollController.dispose();

=======
    _recommendedScrollController.removeListener(_recommendedScrollListener);
    _recommendedScrollController.dispose();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    super.dispose();
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
<<<<<<< HEAD
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
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
                              bottom: BorderSide(
                                  color: Colors.grey.shade800, width: 1),
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('keep_learning'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// GAME
                    if (controller.showGameFirst.value) ...[
                      GameSection(),
                      const SizedBox(height: 40),
                    ],

                    /// TOP USERS
                    SectionHeader(
                      sectionTitle: 'top_users'.tr,
                      onTop: () => desktopKey.currentState?.openSidePage(
                        body: const TopUsersViewAll(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TopUsersSectionDesktop(),

                    const SizedBox(height: 40),

                    const NextSessionSectionDesktop(),

                    const SizedBox(height: 40),

                    RecommendedSectionDesktop(
                      controller: _recommendedScrollController,
                    ),
                    // /// RECOMMENDED
                    // SectionHeader(
                    //   sectionTitle: 'recommended_for_you'.tr,
                    //   onTop: () => desktopKey.currentState?.openSidePage(
                    //     body: const RecommendedViewAll(),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    // RecommendedSectionDesktop(
                    //   controller: _recommendedScrollController,
                    // ),

                    /// GAME
                    if (!controller.showGameFirst.value) ...[
                      const SizedBox(height: 40),
                      GameSection(),
                    ],
                  ],
                ),
              ),
=======
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
                                style: Theme.of(context)
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
                                style: Theme.of(context)
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
                  onTop: () => desktopKey.currentState?.openSidePage(
                    body: BlocProvider(
                      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true),
                      child: const TopUsersViewAll(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    final usersList = state is UsersLoaded ? state.users : [];
                    final isLastPage =
                        state is UsersLoaded ? state.isLastPage : false;

                    return SizedBox(
                      height: 150,
                      child: GridView.builder(
                        controller: _topUsersScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: usersList.isNotEmpty
                            ? (isLastPage
                                ? usersList.length
                                : usersList.length + 1)
                            : 5,
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

                          if (index >= usersList.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final u = usersList[index];

                          return InkWell(
                            onTap: () {
                              desktopKey.currentState?.openSidePage(
                                body: ProfileMentorDesktop(
                                  id: u.id,
                                  name: u.name,
                                  track: u.track.name.isEmpty
                                      ? "Mobile Development"
                                      : u.track.name,
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
                              name: u.name,
                              track: u.track.name.isEmpty
                                  ? "Mobile Development"
                                  : u.track.name,
                              hours: u.helpTotalHours,
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
                  onTop: () => desktopKey.currentState?.openSidePage(
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
                  onTop: () => desktopKey.currentState?.openSidePage(
                    body: BlocProvider(
                      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true),
                      child: const RecommendedViewAll(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    final usersList = state is UsersLoaded ? state.users : [];
                    final isLastPage =
                        state is UsersLoaded ? state.isLastPage : false;

                    return SizedBox(
                      height: 170,
                      child: GridView.builder(
                        controller: _recommendedScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: usersList.isNotEmpty
                            ? (isLastPage
                                ? usersList.length
                                : usersList.length + 1)
                            : 5,
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

                          if (index >= usersList.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final u = usersList[index];

                          return InkWell(
                            onTap: () {
                              desktopKey.currentState?.openSidePage(
                                body: ProfileMentorDesktop(
                                  id: u.id,
                                  name: u.name,
                                  track: u.track.name.isEmpty
                                      ? "Mobile Development"
                                      : u.track.name,
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
                              track: u.track.name.isEmpty
                                  ? "Mobile Development"
                                  : u.track.name,
                              rating: u.rate,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ),
          ),
        ),
      ),
    );
  }
}
