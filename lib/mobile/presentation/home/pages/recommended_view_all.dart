import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../../sign/widgets/custom_appbar.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // عدد الأعمدة responsive
    int crossAxisCount = 2;
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: const [
              CustomAppBar(
                title: 'Recommended for You',
              )
            ],
          ),
          Positioned(
            top: screenHeight * 0.1, // بدل 80
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.9),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.08), // بدل 32
                  topRight: Radius.circular(screenWidth * 0.08), // بدل 32
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04), // بدل 16
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final spacing = screenWidth * 0.04; // بدل 16
                      final itemWidth = (constraints.maxWidth -
                              spacing * (crossAxisCount - 1)) /
                          crossAxisCount;
                      final itemHeight = itemWidth * 1.2;
                      final aspectRatio = itemWidth / itemHeight;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: aspectRatio,
                        ),
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
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
