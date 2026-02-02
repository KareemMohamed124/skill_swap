import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../models/session.dart';
import '../widgets/session_card.dart';

class UpcomingSessionsPage extends StatelessWidget {
  const UpcomingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: AppData.confirmedList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return SessionCard(session:  AppData.confirmedList[index]);
      },
    );
  }
}