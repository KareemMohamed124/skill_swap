import 'package:flutter/material.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/constants/strings.dart';
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
      child: ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: AppData.topUsers.length,
        itemBuilder: (context, index) {
          final user = AppData.topUsers[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: TopUserCard(
              id: user.id,
              image: user.image,
              name: user.name,
              track: user.track,
              hours: user.hours,
            ),
          );
        },
      ),
    );
  }
}
