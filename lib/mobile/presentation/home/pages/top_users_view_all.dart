import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
<<<<<<< HEAD
import '../../book_session/screens/profile_mentor.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../widgets/top_user_card.dart';

class TopUsersViewAll extends StatefulWidget {
  const TopUsersViewAll({super.key});

  @override
  State<TopUsersViewAll> createState() => _TopUsersViewAllState();
}

class _TopUsersViewAllState extends State<TopUsersViewAll> {
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
    final cubit = context.read<UsersCubit>();
<<<<<<< HEAD

    if (!_scrollController.hasClients) return;

    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;

=======
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
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
    double padding = 16;

    if (screenWidth >= 800) {
=======
    double radius = 32;
    double padding = 16;

    if (screenWidth >= 800) {
      radius = 40;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      padding = 24;
    }

    return BaseScreen(
      title: "Top Users",
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
<<<<<<< HEAD
            return const Center(
              child: CircularProgressIndicator(),
            );
=======
            return const Center(child: CircularProgressIndicator());
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          }

          if (state is UsersError) {
            return Center(child: Text(state.message));
          }

          if (state is UsersLoaded) {
<<<<<<< HEAD
            final users = state.users;

            final showLoader = state.isLoadingMore && !state.isLastPage;

            final itemCount = showLoader ? users.length + 1 : users.length;
=======
            final usersList = state.users;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(padding),
<<<<<<< HEAD
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Loader item
                if (index >= users.length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppPalette.primary,
                    ),
                  );
                }

                final user = users[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ProfileMentor(
                        id: user.id,
                        name: user.name,
                        track: user.track.name,
                        rate: user.rate,
                        image: user.userImage.secureUrl,
                        bio: user.profile.bio,
                        skills: user.skills,
                        hoursAvailable: user.freeHours,
                        peopleHelped: user.helpTotalHours,
                        hourlyRate: user.hourlyPrice,
                        reviews: user.reviews,
                        role: user.role,
                      ),
                    );
=======
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

                final user = usersList[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  },
                  child: TopUserCard(
                    id: user.id,
                    image: user.userImage.secureUrl,
                    name: user.name,
<<<<<<< HEAD
                    track: user.track.name.isEmpty
                        ? "Mobile Development"
                        : user.track.name,
=======
                    track: user.track.name ?? "Mobile Development",
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    hours: user.helpTotalHours,
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
