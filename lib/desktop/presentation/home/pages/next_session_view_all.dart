import 'package:flutter/material.dart';
import 'package:skill_swap/main.dart';
import '../../../../shared/constants/strings.dart';
import '../widgets/next_session_card.dart';

class NextSessionViewAll extends StatefulWidget {
  const NextSessionViewAll({super.key});

  @override
  State<NextSessionViewAll> createState() => _NextSessionViewAllState();
}

class _NextSessionViewAllState extends State<NextSessionViewAll> {
  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
                  icon:  Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Next Sessions",
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

          // List of sessions
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView.separated(
                itemCount: AppData.nextSessions.length,
                scrollDirection: Axis.vertical,
                separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.02),
                itemBuilder: (context, index) {
                  final session = AppData.nextSessions[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: NextSessionCard(
                        name: session.name,
                        duration: session.duration,
                        dateTime: session.dateTime,
                        startsIn: session.startsIn,
                        isMentor: session.isMentor,
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