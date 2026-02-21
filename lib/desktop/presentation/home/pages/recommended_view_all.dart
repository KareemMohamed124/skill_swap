import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../main.dart';
import '../widgets/recommended_card.dart';

class RecommendedViewAll extends StatefulWidget {
  const RecommendedViewAll({super.key});

  @override
  State<RecommendedViewAll> createState() => _RecommendedViewAllState();
}

class _RecommendedViewAllState extends State<RecommendedViewAll> {
  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
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
                    return GridView.builder(
                      itemCount: usersList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: cardAspectRatio,
                      ),
                      itemBuilder: (context, index) {
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
                              image: "",
                              name: mentor.name,
                              track: "Flutter",
                              rating: 4,
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
