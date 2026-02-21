import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
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

            return ListView.builder(
              padding: EdgeInsets.all(padding),
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                final mentor = usersList[index];
                return RecommendedCard(
                  id: mentor.id,
                  image: mentor.userImage.secureUrl,
                  name: mentor.name,
                  track: "Flutter",
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
