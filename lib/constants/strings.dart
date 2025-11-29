import 'package:flutter/material.dart';
import 'package:skill_swap/constants/recommended_mentor.dart';
import 'package:skill_swap/constants/session_type_model.dart';
import 'package:skill_swap/constants/top_user.dart';

import 'package:skill_swap/constants/top_user.dart';

import 'next_session.dart';

class AppData {
  static final List<TopUser> topUsers = [
    TopUser(
      image: "assets/images/people_images/Joumana Johnson.png",
      name: "Joumana Johnson",
      track: "Mobile Developer",
      hours: "48 shared",
    ),
   TopUser(
      image: "assets/images/people_images/Youstina Hazem.png",
      name: "Youstina Hazem",
      track: "Ui/Ux Developer",
      hours: "45 shared",
    ),
     TopUser(
      image: "assets/images/people_images/Max Turner.png",
      name: "Max Turner",
      track: "Backend Developer",
      hours: "43 shared",
    ),
     TopUser(
      image: "assets/images/people_images/Liyan Alex.png",
      name: "Liyan Alex",
      track: "Fronted Developer",
      hours: "40 shared",
    ),
  ];

  static  List<NextSession> nextSessions = [
    NextSession(
      image: "assets/images/people_images/Lisa Wang.png",
      name: "Lisa Wang",
      time: "Today, 2:00 PM . 1h . Video Call",
      duration: "• Starts in 10m",
    ),
    NextSession(
      image: "assets/images/people_images/Liyan Alex.png",
      name: "Liyan Alex",
      time: "Today, 6:00 PM . 30m . Chat Session",
      duration: "• Starts in 4h",
    ),
  ];

  static  List<RecommendedMentor> recommendedMentors = [
    RecommendedMentor(
      image: "assets/images/people_images/Maria Garcia.png",
      name: "Maria Garcia",
      stars: "4.9",
      track: "React Development",
    ),
    RecommendedMentor(
      image: "assets/images/people_images/Alex Johson.png",
      name: "Alex Johson",
      stars: "4.8",
      track: "mobile Development",
    ),
    RecommendedMentor(
      image: "assets/images/people_images/Marcus Johnson.png",
      name: "Marcus Johnson",
      stars: "4.7",
      track: "Ui/Ux Development",
    ),
  ];

  static  List<SessionTypeModel> sessionTypes = [
    SessionTypeModel(
      icon: Icons.chat_bubble_outline,
      title: "Text Chat",
      description: "Simple text-based conversation. Great for quick questions.",
    ),
    SessionTypeModel(
      icon: Icons.videocam_outlined,
      title: "Video Call",
      description:
      "Face-to-face conversation with screen sharing capabilities.",
    ),
  ];
}