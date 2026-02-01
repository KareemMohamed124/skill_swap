import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_palette.dart';
import '../../../constants/strings.dart';
import '../widgets/session_card.dart';

class AllSessionsPage extends StatefulWidget {
  const AllSessionsPage({super.key});

  @override
  State<AllSessionsPage> createState() => _AllSessionsPageState();
}

class _AllSessionsPageState extends State<AllSessionsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Sessions",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ?
                    AppPalette.darkTextPrimary : AppPalette.lightTextPrimary
            ),
          ),
          const SizedBox(height: 8,),
          ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: AppData.allList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
      return SessionCard(session: AppData.allList[index]);
      },
      ),
          const SizedBox(height: 24,),
          Text(
            "Your Request",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ?
                AppPalette.darkTextPrimary : AppPalette.lightTextPrimary
            ),
          ),
          const SizedBox(height: 8,),
      ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
        padding: EdgeInsets.zero,
      itemCount: AppData.requestList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
      return SessionCard(session: AppData.requestList[index]);
      },
      )
        ],
      ),
    );
  }
}
