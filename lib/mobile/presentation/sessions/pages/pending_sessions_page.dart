import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../models/session.dart';
import '../widgets/session_card.dart';

class PendingSessionsPage extends StatelessWidget {
  const PendingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return  ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: AppData.pendingList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return SessionCard(session: AppData.pendingList[index]);
      },
    );
  }
}