import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../widgets/session_card.dart';

class UpcomingSessionsPage extends StatelessWidget {
  const UpcomingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
      itemCount: AppData.confirmedList.length,
      separatorBuilder: (_, __) =>
          SizedBox(height: screenHeight * 0.02), // responsive spacing
      itemBuilder: (context, index) {
        return SessionCard(session: AppData.confirmedList[index]);
      },
    );
  }
}
