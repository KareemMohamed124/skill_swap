import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';
import '../../../../shared/dependency_injection/injection.dart';

import '../../../../mobile/presentation/home/models/user_rank.dart';
=======
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../widgets/recommended_card.dart';

class RecommendedViewAll extends StatefulWidget {
  const RecommendedViewAll({super.key});

  @override
  State<RecommendedViewAll> createState() => _RecommendedViewAllState();
}

class _RecommendedViewAllState extends State<RecommendedViewAll> {
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
<<<<<<< HEAD
    final bloc = context.read<UserFilterBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoadingMore &&
        !state.isLastPage) {
      bloc.add(
        LoadMoreUsersEvent(
          page: bloc.currentPage + 1,
          track: state.selectedTrack,
        ),
      );
=======
    final cubit = context.read<UsersCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;
      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, profileState) {
          if (profileState is! MyProfileLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final track = profileState.profile.track.name ?? '';

          return BlocProvider(
            create: (_) =>
            UserFilterBloc(
              userRepository: sl(),
              allUsers: [],
            )
              ..add(ApplyFiltersEvent(track: track)),

            child: Column(
              children: [

                /// 🔥 HEADER
                Container(
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
                      IconButton(
                        onPressed: () {
                          final didGoBack =
                          desktopKey.currentState?.goBack();
                          if (didGoBack == false) {
                            desktopKey.currentState?.openPage(index: 0);
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Recommended for You",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                /// 🔥 GRID
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: BlocBuilder<UserFilterBloc, UserFilterState>(
                      builder: (context, state) {
                        final rankedList = rankRecommendedUsers(
                          state.filteredList,
                          state.selectedTrack,
                        );

                        if (state.isLoading && rankedList.isEmpty) {
=======
    final screenWidth = MediaQuery.of(context).size.width;

    // Columns based on Desktop width
    int crossAxisCount = 4;
    double cardAspectRatio = 0.85;

    if (screenWidth < 1400) {
      crossAxisCount = 3;
      cardAspectRatio = 1.2;
    }
    if (screenWidth < 1000) {
      crossAxisCount = 2;
      cardAspectRatio = 1.1;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade800, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final didGoBack = desktopKey.currentState?.goBack();
                    if (didGoBack == false) {
                      desktopKey.currentState?.openPage(index: 0);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Recommended for You",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                    final itemCount = state.isLastPage
                        ? usersList.length
                        : usersList.length + 1;

                    return GridView.builder(
                      controller: _scrollController,
                      itemCount: itemCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: cardAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        if (index >= usersList.length) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                          return const Center(
                              child: CircularProgressIndicator());
                        }

<<<<<<< HEAD
                        if (!state.isLoading && rankedList.isEmpty) {
                          return const Center(
                            child: Text("No recommendations found"),
                          );
                        }

                        return GridView.builder(
                          controller: _scrollController,
                          itemCount: state.isLastPage
                              ? rankedList.length
                              : rankedList.length + 1,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, index) {
                            if (index < rankedList.length) {
                              final user = rankedList[index];

                              return RecommendedCard(
                                id: user.id,
                                image: user.userImage.secureUrl,
                                name: user.name,
                                track: user.track.name,
                                rating: user.rate,
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
=======
                        final mentor = usersList[index];
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: RecommendedCard(
                              id: mentor.id,
                              image: mentor.userImage.secureUrl,
                              name: mentor.name,
                              track: "Flutter",
                              rating: mentor.rate,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
