import 'package:flutter/material.dart';

import '../../../../shared/constants/strings.dart';
import '../widgets/history_card.dart';

class CancelSessionsPage extends StatelessWidget {
  const CancelSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return  ListView.separated(
      //physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: AppData.cancelledSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: AppData.cancelledSessions[index]);
      },
    );
  }
}