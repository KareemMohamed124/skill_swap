import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:skill_swap/desktop/presentation/common/desktop_screen_manager.dart';
import '../../../../main.dart';
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

    // Columns based on Desktop width
    int crossAxisCount = 4;
    double cardAspectRatio = 1.3;

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
                    if(didGoBack == false) {
                      desktopKey.currentState?.openPage(index: 0);
                    }
                  },
                  icon:Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Top Users",
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
              child: GridView.builder(
                itemCount: AppData.topUsers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: cardAspectRatio,
                ),
                itemBuilder: (context, index) {
                  final user = AppData.topUsers[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
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
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}