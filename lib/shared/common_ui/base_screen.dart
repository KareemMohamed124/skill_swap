import 'package:flutter/material.dart';

import '../../mobile/presentation/sign/widgets/custom_appbar.dart';

/// Base Stacked Screen
class BaseScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const BaseScreen({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
<<<<<<< HEAD
      resizeToAvoidBottomInset: false, // ✅
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅
=======
      backgroundColor: Colors.white,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: title),
            ],
          ),
          Positioned(
            top: screenHeight * 0.09,
<<<<<<< HEAD
=======
            // بدل 80
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
<<<<<<< HEAD
              constraints: const BoxConstraints(),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.08),
                  topRight: Radius.circular(screenWidth * 0.08),
=======
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.08), // بدل 32
                  topRight: Radius.circular(screenWidth * 0.08), // بدل 32
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                ),
              ),
              child: child,
            ),
<<<<<<< HEAD
          ),
=======
          )
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ],
      ),
    );
  }
}
