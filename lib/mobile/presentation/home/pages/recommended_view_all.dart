import 'package:flutter/material.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/constants/strings.dart';
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
      child: ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: AppData.recommendedMentors.length,
        itemBuilder: (context, index) {
          final mentor = AppData.recommendedMentors[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: RecommendedCard(
              id: mentor.id,
              image: mentor.image,
              name: mentor.name,
              track: mentor.track,
              rating: mentor.stars,
            ),
          );
        },
      ),
    );
  }
}
