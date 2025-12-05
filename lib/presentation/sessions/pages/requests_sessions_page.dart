import 'package:flutter/material.dart';
import 'package:skill_swap/constants/strings.dart';
import '../models/session.dart';
import '../widgets/session_card.dart';

class RequestsSessionsPage extends StatelessWidget {
  const RequestsSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: AppData.requestList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return SessionCard(session: AppData.requestList[index]);
      },
    );

  }
}