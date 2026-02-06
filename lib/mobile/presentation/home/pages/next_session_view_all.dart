import 'package:flutter/material.dart';
import '../../../../shared/constants/strings.dart';
import '../../sign/widgets/custom_appbar.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: const [
              CustomAppBar(title: 'Next Sessions'),
            ],
          ),
          Positioned(
            top: screenHeight * 0.1, // بدل 80
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.9),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.08),
                  topRight: Radius.circular(screenWidth * 0.08),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04), // بدل 16
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: AppData.nextSessions.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: screenHeight * 0.02), // بدل 16
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
