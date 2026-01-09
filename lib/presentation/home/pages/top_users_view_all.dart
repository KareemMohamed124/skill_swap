import 'package:flutter/material.dart';
import 'package:skill_swap/constants/strings.dart';
import 'package:skill_swap/presentation/home/widgets/top_user_card.dart';

import '../../../constants/colors.dart';
import '../../sign/widgets/custom_appbar.dart';

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

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: const [
              CustomAppBar(title: 'Top Users',)
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
                    childAspectRatio: 1.2,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(AppData.topUsers.length, (index) {
                      final isSelected = selectedIndex == index;
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