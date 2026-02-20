import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/desktop/presentation/select_skills/select_skills.dart';

import '../../../shared/bloc/tracks_cubit/tracks_cubit.dart';
import '../../../shared/data/models/track/track_model.dart';

/// Local map: track name → list of skills (API only returns id + name)
const Map<String, List<String>> tracksWithSkillsMap = {
  "Mobile Development": [
    "Dart & Flutter",
    "Java/Kotlin & Android",
    "Swift & iOS",
    "Firebase & Backend Services",
  ],
  "Frontend Development": [
    "HTML & CSS",
    "JavaScript & React",
    "JavaScript & Angular",
    "JavaScript & Vue",
  ],
  "Backend Development": [
    "JavaScript & NodeJS",
    "PHP & Laravel",
    "Python & Django",
    "SQL & Database Management",
  ],
  "UI/UX Design": [
    "Figma & UI Design",
    "Adobe XD & Prototyping",
    "User Research & UX Strategy",
  ],
  "Artificial Intelligence": [
    "Python & TensorFlow",
    "Python & PyTorch",
    "Python & NLP",
    "Python & Computer Vision",
  ],
  "Data Science": [
    "Python & Pandas",
    "Python & NumPy",
    "Python & Data Visualization",
    "R & Statistical Analysis",
  ],
  "Game Development": [
    "C# & Unity",
    "C++ & Unreal Engine",
    "Blender & 3D Design",
  ],
  "Cybersecurity": [
    "Linux & Networking",
    "Python & Security Automation",
    "Penetration Testing & OWASP",
  ],
  "Cloud Computing": [
    "Docker & Containerization",
    "Kubernetes & Orchestration",
    "AWS & Cloud Services",
    "CI/CD & DevOps",
  ],
  "Software Testing": [
    "Dart & Flutter Testing",
    "Java & Selenium",
    "Automation & Test Frameworks",
  ],
};

class SelectTrackScreen extends StatelessWidget {
  const SelectTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<TracksCubit>()..fetchTracks(),
      child: const _SelectTrackBody(),
    );
  }
}

class _SelectTrackBody extends StatefulWidget {
  const _SelectTrackBody();

  @override
  State<_SelectTrackBody> createState() => _SelectTrackBodyState();
}

class _SelectTrackBodyState extends State<_SelectTrackBody> {
  TrackModel? selectedTrack;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            Text(
              "Select your Track",
              style: TextStyle(
                fontSize: size.width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Choose the track you already have. This will help us connect you with the right mentors and users.",
              style: TextStyle(fontSize: size.width * 0.035),
            ),
            SizedBox(height: size.height * 0.03),

            /// 🔥 Tracks Chips (fetched from API)
            Expanded(
              child: BlocBuilder<TracksCubit, TracksState>(
                builder: (context, state) {
                  if (state is TracksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TracksError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<TracksCubit>().fetchTracks(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is TracksLoaded) {
                    final tracks = state.tracks;
                    if (tracks.isEmpty) {
                      return const Center(
                        child: Text("No tracks available."),
                      );
                    }
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: size.width * 0.02,
                        runSpacing: size.height * 0.015,
                        children: tracks.map((track) {
                          final isSelected = selectedTrack?.id == track.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTrack = track;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04,
                                vertical: size.height * 0.012,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xff0D0B5C)
                                    : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xff0D0B5C)
                                      : Theme.of(context).dividerColor,
                                ),
                              ),
                              child: Text(
                                track.name,
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            SizedBox(height: size.height * 0.02),

            /// 🔥 Continue Button
            Center(
              child: SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: selectedTrack == null
                      ? null
                      : () {
                          // Look up skills from local map by track name
                          final skills =
                              tracksWithSkillsMap[selectedTrack!.name] ?? [];

                          Get.to(
                            SelectSkillsScreen(
                              trackId: selectedTrack!.id,
                              trackName: selectedTrack!.name,
                              skills: skills,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0D0B5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
