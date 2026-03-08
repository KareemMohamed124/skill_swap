import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'leaderboard_screen.dart';

class GameSection extends StatefulWidget {
  const GameSection({super.key});

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  final PageController _controller = PageController(viewportFraction: 0.82);

  int _currentPage = 0;
  Timer? _timer;

  static const Color primaryColor = Color(0xFF3F51B5);

  final List<String> images = [
    "assets/images/people_images/Ahmed Ibrahim.png",
    "assets/images/people_images/Ahmed Ibrahim.png",
    "assets/images/people_images/Ahmed Ibrahim.png",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "🎮 Challenge",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeaderboardScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events, color: primaryColor),
              label: Text(
                "View Leaderboard",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          ],
        ),

        const SizedBox(height: 15),

        /// Carousel
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final bool isActive = index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: isActive ? 10 : 25,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),

        /// Indicator
        Center(
          child: SmoothPageIndicator(
            controller: _controller,
            count: images.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: primaryColor,
              dotColor: Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }
}
