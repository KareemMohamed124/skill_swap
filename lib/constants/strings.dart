import 'package:flutter/material.dart';
import 'package:skill_swap/constants/notification_model.dart';
import 'package:skill_swap/constants/recommended_mentor.dart';
import 'package:skill_swap/constants/session_type.dart';
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

  static List<NotificationModel> notificationCard = [
    NotificationModel(
      bgColor: Color(0xFFD6D6D6).withValues(alpha: 0.25),
      borderColor: Color(0xFFD6D6D6),
      tag: "Reminder",
      tagColor: Colors.grey,
      timeAgo: "10 min ago",
      title: "Reminder: Your mentorship session starts in 30 minutes.",
      mentorName: "Sarah Johnson",
      sessionTime: "Nov 25 at 2:00 PM",
      icon: Icons.notifications_none_outlined
    ),
    NotificationModel(
      bgColor: Colors.green.shade50,
      borderColor: Colors.green.shade200,
      tag: "Approved",
      tagColor: Colors.green,
      timeAgo: "2 hours ago",
      title: "Your session has been Approved!",
      mentorName: "Michael Chen",
      sessionTime: "Nov 25 at 2:00 PM",
      icon: Icons.check_circle_outline
    ),
    NotificationModel(
      bgColor: Colors.blue.shade50,
      borderColor: Colors.blue.shade200,
      tag: "Past session",
      tagColor: Colors.blue,
      timeAgo: "5 hours ago",
      title: "Rate your session with the mentor.",
      mentorName: "Emily Rodriguez",
      sessionTime: "",
      icon: Icons.star_border
    ),
    NotificationModel(
      bgColor: Colors.yellow.shade50,
      borderColor: Colors.yellow.shade300,
      tag: "Pending",
      tagColor: Colors.orange,
      timeAgo: "1 day ago",
      title: "Your session request is pending approval.",
      mentorName: "David Kumar",
      sessionTime: "Nov 28 at 10:00 AM",
      icon: Icons.access_time
    ),
    NotificationModel(
      bgColor: Colors.red.shade50,
      borderColor: Colors.red.shade300,
      tag: "Rejected",
      tagColor: Colors.red,
      timeAgo: "2 day ago",
      title:
      "Your session request was declined.\nReason: Schedule conflict.",
      mentorName: "Sarah Johnson",
      sessionTime: "",
      icon: Icons.cancel_outlined
    ),
  ];
}