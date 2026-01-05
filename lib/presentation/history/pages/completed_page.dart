import 'package:flutter/material.dart';
import 'package:skill_swap/constants/strings.dart';
import 'package:skill_swap/presentation/history/widgets/history_card.dart';


class CompletedSessionsPage extends StatelessWidget {
  const CompletedSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return  ListView.separated(
      //physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: AppData.completedSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: AppData.completedSessions[index]);
      },
    );
  }
}