import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../../sign/widgets/custom_appbar.dart';
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
              CustomAppBar(title: 'Top Users'),
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
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: screenWidth * 0.04, // بدل 16
                      crossAxisSpacing: screenWidth * 0.04, // بدل 16
                      childAspectRatio: 1.2,
                    ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
