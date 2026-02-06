import 'package:flutter/material.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    double radius = 32;
    double padding = 16;

    if (screenWidth >= 800) {
      radius = 40;
      padding = 24;
    }

    return BaseScreen(
      title: "Next Sessions",
      child: ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: AppData.nextSessions.length,
        itemBuilder: (context, index) {
          final session = AppData.nextSessions[index];
          return NextSessionCard(
            name: session.name,
            duration: session.duration,
            dateTime: session.dateTime,
            startsIn: session.startsIn,
            isMentor: session.isMentor,
          );
        },
      ),
    );
  }
}
