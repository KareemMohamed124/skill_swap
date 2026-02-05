import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/sessions/models/session.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/session_card.dart';

class AllSessionsPage extends StatefulWidget {
  const AllSessionsPage({super.key});

  @override
  State<AllSessionsPage> createState() => _AllSessionsPageState();
}

class _AllSessionsPageState extends State<AllSessionsPage> {
  @override
  Widget build(BuildContext context) {
    List<Session> allList = [
      Session(
          id: "1",
          image: "assets/images/people_images/Leo Wong.png",
          name: "Leo Wong",
          role: "Software Engineer",
          type: "Video Call",
          dateTime: DateTime(2025, 1, 12, 14, 00),
          price: "40",
          status: "Confirmed",
          timeAgo: ""
      ),
      Session(
          id: "2",
          image: "assets/images/people_images/Sarah Smith.png",
          name: "Sarah Smith",
          role: "Mentor",
          type: "Video Session",
          dateTime: DateTime.now().add(const Duration(days: 1)),
          price: "30",
          status: "PendingApproval",
          timeAgo: ""
      ),
      Session(
          id: "3",
          image: "assets/images/people_images/Marcus Johnson.png",
          name: "Marcus Johnson",
          role: "Student",
          type: "Video Session",
          dateTime: DateTime(2025, 1, 13, 11, 00),
          price: "Free",
          status: "Live Now",
          timeAgo: ""
      ),
    ];
    List<Session> requestList = [
      Session(
          id: "1",
          image: "assets/images/people_images/Alex Johnson.png",
          name: "Alex Johnson",
          role: "React Development",
          type: "Video Session",
          dateTime: DateTime(2025, 1, 10, 11, 00),
          price: "Free",
          status: "NewRequest",
          timeAgo: "10 min ago"
      ),
      Session(
          id: "2",
          image: "assets/images/people_images/Moritz Garcia.png",
          name: "Moritz Garcia",
          role: "System Engineering",
          type: "Video Call",
          dateTime: DateTime(2025, 1, 10, 14, 30),
          price: "Free",
          status: "NewRequest",
          timeAgo: "2 hours ago"
      ),
      Session(
          id: "3",
          image: "assets/images/people_images/Aya Ahmed.png",
          name: "Aya Ahmed",
          role: "UI/UX Design",
          type: "1:1 Session",
          dateTime: DateTime(2025, 1, 11, 16, 00),
          price: "Free",
          status: "NewRequest",
          timeAgo: "5 hours ago"
      ),
    ];


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
      itemCount: allList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
      return SessionCard(session: allList[index]);
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
      itemCount: requestList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
      return SessionCard(session: requestList[index]);
      },
      )
        ],
      ),
    );
  }
}
