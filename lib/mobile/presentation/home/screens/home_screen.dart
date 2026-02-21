import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/game_part/game_section.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../shared/constants/strings.dart';
import '../../../../shared/helper/home_controller.dart';
import '../../book_session/screens/profile_mentor.dart';
import '../pages/next_session_view_all.dart';
import '../pages/recommended_view_all.dart';
import '../pages/top_users_view_all.dart';
import '../widgets/custom_header.dart';
import '../widgets/next_session_card.dart';
import '../widgets/recommended_card.dart';
import '../widgets/section_header.dart';
import '../widgets/top_user_card.dart';
import '../widgets/unreal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().fetchUsers();
    context.read<MyProfileCubit>().fetchMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              BlocBuilder<MyProfileCubit, MyProfileState>(
                builder: (context, state) {
                  String name = "User";
                  String avatarPath = 'assets/images/placeholder.png';

                  if (state is MyProfileLoaded) {
                    name = state.profile.name ?? name;
                    if (state.profile.userImage?.secureUrl?.isNotEmpty ==
                        true) {
                      avatarPath = state.profile.userImage!.secureUrl!;
                    }
                  }

                  return CustomHeader(
                    name: 'Hi, $name',
                    subtitle: 'keep_learning'.tr,
                    avatarPath: avatarPath,
                    onIcon1: () {},
                    onIcon2: () {
                      //  Get.to(() => const NotificationsScreen());
                      // Get.to(() => CallPage(
                      //       callID: 'Test User',
                      //     ));
                    },
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.85),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.06),
                  topRight: Radius.circular(screenWidth * 0.06),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    ///Game
                    children: controller.showGameFirst.value
                        ? [
                            GameSection(),

                            SizedBox(height: screenHeight * 0.03),

                            /// Top Users Section
                            SectionHeader(
                              sectionTitle: 'top_users'.tr,
                              onTop: () {
                                Get.to(BlocProvider.value(
                                  value: context.read<UsersCubit>(),
                                  child: TopUsersViewAll(),
                                ));
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            SizedBox(
                              height: screenHeight * 0.18,
                              child: BlocBuilder<UsersCubit, UsersState>(
                                builder: (context, state) {
                                  final usersList =
                                      state is UsersLoaded ? state.users : [];

                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: usersList.isNotEmpty
                                        ? usersList.length
                                        : 5, // 5 placeholders
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: screenWidth * 0.04),
                                    itemBuilder: (context, index) {
                                      if (usersList.isEmpty) {
                                        return const TopUserCard(
                                          isLoading: true,
                                        );
                                      }

                                      final u = usersList[index];
                                      final avatar =
                                          u.userImage.secureUrl.isNotEmpty
                                              ? u.userImage.secureUrl
                                              : '';

                                      return InkWell(
                                        onTap: () {
                                          Get.to(ProfileMentor(
                                            id: u.id,
                                            name: u.name,
                                            track: "Flutter",
                                            rate: u.rate,
                                            image: avatar,
                                          ));
                                        },
                                        child: TopUserCard(
                                          id: u.id,
                                          image: avatar,
                                          name: u.name,
                                          track: "Flutter",
                                          hours: u.helpTotalHours,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            /// Next Session Section
                            SectionHeader(
                              sectionTitle: 'your_next_session'.tr,
                              onTop: () {
                                Get.to(NextSessionViewAll());
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: AppData.nextSessions.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: screenHeight * 0.01),
                              itemBuilder: (context, index) {
                                final s = AppData.nextSessions[index];
                                return NextSessionCard(
                                  name: s.name,
                                  duration: s.duration,
                                  dateTime: s.dateTime,
                                  startsIn: s.startsIn,
                                  isMentor: s.isMentor,
                                );
                              },
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            /// Recommended Section
                            SectionHeader(
                              sectionTitle: 'recommended_for_you'.tr,
                              onTop: () {
                                Get.to(BlocProvider.value(
                                  value: context.read<UsersCubit>(),
                                  child: RecommendedViewAll(),
                                ));
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            SizedBox(
                              height: screenHeight * 0.21,
                              child: BlocBuilder<UsersCubit, UsersState>(
                                builder: (context, state) {
                                  final usersList =
                                      state is UsersLoaded ? state.users : [];

                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: usersList.isNotEmpty
                                        ? usersList.length
                                        : 5,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: screenWidth * 0.04),
                                    itemBuilder: (context, index) {
                                      if (usersList.isEmpty) {
                                        return const RecommendedCard(
                                          isLoading: true,
                                        );
                                      }

                                      final u = usersList[index];
                                      final avatar =
                                          u.userImage.secureUrl.isNotEmpty
                                              ? u.userImage.secureUrl
                                              : '';

                                      return RecommendedCard(
                                        id: u.id,
                                        image: avatar,
                                        name: u.name,
                                        track: "Flutter",
                                        rating: u.rate,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),
                            UnrealExperienceCard(),
                          ]
                        : [
                            /// Top Users Section
                            SectionHeader(
                              sectionTitle: 'top_users'.tr,
                              onTop: () {
                                Get.to(BlocProvider.value(
                                  value: context.read<UsersCubit>(),
                                  child: TopUsersViewAll(),
                                ));
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            SizedBox(
                              height: screenHeight * 0.18,
                              child: BlocBuilder<UsersCubit, UsersState>(
                                builder: (context, state) {
                                  final usersList =
                                      state is UsersLoaded ? state.users : [];

                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: usersList.isNotEmpty
                                        ? usersList.length
                                        : 5, // 5 placeholders
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: screenWidth * 0.04),
                                    itemBuilder: (context, index) {
                                      if (usersList.isEmpty) {
                                        return const TopUserCard(
                                          isLoading: true,
                                        );
                                      }

                                      final u = usersList[index];
                                      final avatar =
                                          u.userImage.secureUrl.isNotEmpty
                                              ? u.userImage.secureUrl
                                              : '';

                                      return InkWell(
                                        onTap: () {
                                          Get.to(ProfileMentor(
                                            id: u.id,
                                            name: u.name,
                                            track: "Flutter",
                                            rate: u.rate,
                                            image: u.userImage.secureUrl,
                                          ));
                                        },
                                        child: TopUserCard(
                                          id: u.id,
                                          image: avatar,
                                          name: u.name,
                                          track: "Flutter",
                                          hours: u.helpTotalHours,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            /// Next Session Section
                            SectionHeader(
                              sectionTitle: 'your_next_session'.tr,
                              onTop: () {
                                Get.to(NextSessionViewAll());
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: AppData.nextSessions.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: screenHeight * 0.01),
                              itemBuilder: (context, index) {
                                final s = AppData.nextSessions[index];
                                return NextSessionCard(
                                  name: s.name,
                                  duration: s.duration,
                                  dateTime: s.dateTime,
                                  startsIn: s.startsIn,
                                  isMentor: s.isMentor,
                                );
                              },
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            /// Recommended Section
                            SectionHeader(
                              sectionTitle: 'recommended_for_you'.tr,
                              onTop: () {
                                Get.to(BlocProvider.value(
                                  value: context.read<UsersCubit>(),
                                  child: RecommendedViewAll(),
                                ));
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            SizedBox(
                              height: screenHeight * 0.21,
                              child: BlocBuilder<UsersCubit, UsersState>(
                                builder: (context, state) {
                                  final usersList =
                                      state is UsersLoaded ? state.users : [];

                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: usersList.isNotEmpty
                                        ? usersList.length
                                        : 5,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: screenWidth * 0.04),
                                    itemBuilder: (context, index) {
                                      if (usersList.isEmpty) {
                                        return const RecommendedCard(
                                          isLoading: true,
                                        );
                                      }

                                      final u = usersList[index];
                                      final avatar =
                                          u.userImage.secureUrl.isNotEmpty
                                              ? u.userImage.secureUrl
                                              : '';

                                      return RecommendedCard(
                                        id: u.id,
                                        image: u.userImage.secureUrl,
                                        name: u.name,
                                        track: "Flutter",
                                        rating: u.rate,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),
                            GameSection(),
                          ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
