import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/home/widgets/recommended_card.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../sign/widgets/custom_appbar.dart';

class RecommendedViewAll extends StatefulWidget {
  const RecommendedViewAll({super.key});

  @override
  State<RecommendedViewAll> createState() => _RecommendedViewAllState();
}

class _RecommendedViewAllState extends State<RecommendedViewAll> {
  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: const [
              CustomAppBar(title: 'Recommended for You',)
            ],
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(AppData.recommendedMentors.length, (index) {
                      final isSelected = selectedIndex == index;
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
                          )
                      );
                    }),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}