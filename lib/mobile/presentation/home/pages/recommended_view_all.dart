import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/recommended_card.dart';

class RecommendedViewAll extends StatefulWidget {
  const RecommendedViewAll({super.key});

  @override
  State<RecommendedViewAll> createState() => _RecommendedViewAllState();
}

class _RecommendedViewAllState extends State<RecommendedViewAll> {
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

    return BaseScreen(
      title: "Recommend for You",
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

                final mentor = usersList[index];
                return RecommendedCard(
                  id: mentor.id,
                  image: mentor.userImage.secureUrl,
                  name: mentor.name,
                  track: mentor.track.name ?? "Mobile Development",
                  rating: mentor.rate,
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
