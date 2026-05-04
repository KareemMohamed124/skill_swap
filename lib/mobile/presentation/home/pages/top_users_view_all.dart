import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/top_user_card.dart';

class TopUsersViewAll extends StatefulWidget {
  const TopUsersViewAll({super.key});

  @override
  State<TopUsersViewAll> createState() => _TopUsersViewAllState();
}

class _TopUsersViewAllState extends State<TopUsersViewAll> {
  int? selectedIndex = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final cubit = context.read<UsersCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
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

    double radius = 32;
    double padding = 16;

    if (screenWidth >= 800) {
      radius = 40;
      padding = 24;
    }

    double aspectRatio;

    if (screenWidth < 360) {
      aspectRatio = 0.6; // موبايلات صغيرة قوي
    } else if (screenWidth < 400) {
      aspectRatio = 0.65;
    } else if (screenWidth < 450) {
      aspectRatio = 0.7;
    } else {
      aspectRatio = 0.75; // موبايلات كبيرة
    }

    return BaseScreen(
      title: "Top Users",
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

            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75),
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
                  },
                  child: TopUserCard(
                    id: user.id,
                    image: user.userImage.secureUrl,
                    name: user.name,
                    track: user.track.name ?? "Mobile Development",
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
