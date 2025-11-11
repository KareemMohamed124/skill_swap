import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.topRight, child: skipIntro(context)),

            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: const [
                  OnBoardingPage(
                    imagePath:
                        "assets/images/onboarding_images/onboarding_one.json",
                    title: "Learn from Experts",
                    subtitle:
                        "Connect with verified mentors and skilled developers.",
                  ),
                  OnBoardingPage(
                    imagePath:
                        "assets/images/onboarding_images/onboarding_one.json",
                    title: "Free Learning Hours.",
                    subtitle:
                        "Get 4 free learning hours every week to grow your skills.",
                  ),
                  OnBoardingPage(
                    imagePath:
                        "assets/images/onboarding_images/onboarding_one.json",
                    title: "Skill Verification.",
                    subtitle:
                        "Take assessments to verify your skills and become a mentor.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 42),

            navagationalBar(),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: mainColor,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
              onPressed: () {
                if (currentPage < 2) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SignInScreen()),
                  );
                }
              },
              child: Text(
                currentPage == 2 ? "Get Started" : "Next",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: grayColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navagationalBar() {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: const ExpandingDotsEffect(
        activeDotColor: mainColor,
        dotHeight: 6,
      ),
    );
  }

  Widget skipIntro(BuildContext context) {
    return TextButton(
      onPressed: () {
        print("Skip pressed!");
      },
      child: const Text(
        "skip",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: mainColor,
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  const OnBoardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          imagePath,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: mainColor,
          ),
        ),
        const SizedBox(height: 42),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
