import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../widgets/top_user_card.dart';

class TopUsersViewAll extends StatefulWidget {
  const TopUsersViewAll({super.key});

  @override
  State<TopUsersViewAll> createState() => _TopUsersViewAllState();
}

class _TopUsersViewAllState extends State<TopUsersViewAll> {
  int? selectedIndex = 1;

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

            return ListView.builder(
              padding: EdgeInsets.all(padding),
              itemCount: usersList.length,
              itemBuilder: (context, index) {
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
                    track: "Flutter",
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
