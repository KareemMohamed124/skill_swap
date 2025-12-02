import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
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

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: const [
              CustomAppBar(title: 'Next Sessions',)
            ],
          ),
          Positioned(
            top: 96,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child:  Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: AppData.nextSessions.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final session = AppData.nextSessions[index];
                    return NextSessionCard(
                      image: session.image,
                      name: session.name,
                      duration: session.duration,
                      time: session.time,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}