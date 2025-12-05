import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/book_session/models/session_type_model.dart';
import 'package:skill_swap/presentation/notification/models/notification_model.dart';
import 'package:skill_swap/presentation/home/models/recommended_mentor.dart';
import 'package:skill_swap/presentation/home/models/top_user.dart';

import 'package:skill_swap/presentation/home/models/top_user.dart';

import '../presentation/sessions/models/session.dart';
import '../presentation/search/models/mentor_model.dart';
import '../presentation/home/models/next_session.dart';

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
      image: "assets/images/people_images/Alex Johnson.png",
      name: "Alex Johnson",
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

  static List<MentorModel> mentors = [
    MentorModel(
      image: "assets/images/people_images/Joumana Johnson.png",
      name: "Joumana Johnson",
      status: "Busy",
      rate: 4.9,
      hours: 200,
      price: 35,
      skills: ["React", "JavaScript", "Html", "+7 more"],
      responseTime: "4 hours",
      track: "Frontend",
    ),

    MentorModel(
      image: "assets/images/people_images/Max Turner.png",
      name: "Max Turner",
      status: "Available",
      rate: 4.5,
      hours: 150,
      price: 25,
      skills: ["Dart", "Flutter", "IOS", "+3 more"],
      responseTime: "2 hours",
      track: "Mobile",
    ),

    MentorModel(
      image: "assets/images/people_images/Youstina Hazem.png",
      name: "Youstina Hazem",
      status: "Busy",
      rate: 4.4,
      hours: 95,
      price: 20,
      skills: ["Figma", "Adobe XD", "UI/UX", "+7 more"],
      responseTime: "3 hours",
      track: "Ui/Ux",
    ),

    MentorModel(
      image: "assets/images/people_images/Amir Zahir.png",
      name: "Amir Zahir",
      status: "Available",
      rate: 4.0,
      hours: 85,
      price: 20,
      skills: ["React", "JavaScript", "Html", "+7 more"],
      responseTime: "1 hour",
      track: "Frontend",
    ),

    MentorModel(
      image: "assets/images/people_images/Sarah Ali.png",
      name: "Sarah Ali",
      status: "Available",
      rate: 5.0,
      hours: 300,
      price: 40,
      skills: ["Flutter", "Dart", "Firebase", "+5 more"],
      responseTime: "30 minutes",
      track: "Mobile",
    ),

    MentorModel(
      image: "assets/images/people_images/Mohamed Salah.png",
      name: "Mohamed Salah",
      status: "Busy",
      rate: 3.9,
      hours: 120,
      price: 18,
      skills: ["Python", "Django", "AI", "+6 more"],
      responseTime: "5 hours",
      track: "Backend",
    ),

    MentorModel(
      image: "assets/images/people_images/Lara Smith.png",
      name: "Lara Smith",
      status: "Available",
      rate: 4.7,
      hours: 250,
      price: 32,
      skills: ["Figma", "UX Research", "Wireframing", "+4 more"],
      responseTime: "6 hours",
      track: "Ui/Ux",
    ),

    MentorModel(
      image: "assets/images/people_images/Hazem Tarek.png",
      name: "Hazem Tarek",
      status: "Available",
      rate: 4.8,
      hours: 210,
      price: 28,
      skills: ["Node.js", "Express", "MongoDB", "+3 more"],
      responseTime: "1 hour",
      track: "Backend",
    ),

    MentorModel(
      image: "assets/images/people_images/Emma Jones.png",
      name: "Emma Jones",
      status: "Busy",
      rate: 4.2,
      hours: 140,
      price: 22,
      skills: ["React Native", "JavaScript", "APIs", "+7 more"],
      responseTime: "3 hours",
      track: "Mobile",
    ),

    MentorModel(
      image: "assets/images/people_images/Youssef Samir.png",
      name: "Youssef Samir",
      status: "Available",
      rate: 3.5,
      hours: 60,
      price: 15,
      skills: ["HTML", "CSS", "Bootstrap", "+2 more"],
      responseTime: "1 hour",
      track: "Frontend",
    ),
  ];

  static List<Session> pendingList = [
    Session(
      id: "1",
      image: "assets/images/people_images/Marcus Johnson.png",
      name: "Marcus Johnson",
      role: "Mentor",
      type: "Video Call",
      dateTime: DateTime.now(),
      price: "25",
      status: "PendingApproval",
      timeAgo: ""
    ),
    Session(
      id: "2",
      image: "assets/images/people_images/Sarah Smith.png",
      name: "Sarah Smith",
      role: "Mentor",
      type: "1:1 Session",
      dateTime: DateTime.now().add(const Duration(days: 1)),
      price: "30",
      status: "PendingApproval",
      timeAgo: ""
    ),
    Session(
      id: "3",
      image: "assets/images/people_images/Alex Brown.png",
      name: "Alex Brown",
      role: "Mentor",
      type: "Video Call",
      dateTime: DateTime.now().add(const Duration(days: 2)),
      price: "20",
      status: "PendingApproval",
      timeAgo: ""
    ),
  ];

  static List<Session> confirmedList = [
    Session(
      id: "1",
      image: "assets/images/people_images/Joumana Johnson.png",
      name: "Joumana Johnson",
      role: "Mentor",
      type: "Chat Session",
      dateTime: DateTime(2025, 1, 12, 10, 30),
      price: "35",
      status: "Confirmed",
      timeAgo: ""
    ),
    Session(
      id: "2",
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
      id: "3",
      image: "assets/images/people_images/Marcus Johnson.png",
      name: "Marcus Johnson",
      role: "Mentor",
      type: "1:1 Session",
      dateTime: DateTime(2025, 1, 13, 11, 00),
      price: "Free",
      status: "Live Now",
      timeAgo: ""
    ),
    Session(
      id: "4",
      image: "assets/images/people_images/Sarah Smith.png",
      name: "Sarah Smith",
      role: "UI/UX Designer",
      type: "Chat Session",
      dateTime: DateTime(2025, 1, 13, 16, 30),
      price: "Free",
      status: "Live Now",
      timeAgo: ""
    ),
    Session(
      id: "5",
      image: "assets/images/people_images/Ahmed Ibrahim.png",
      name: "Ahmed Ibrahim",
      role: "Mobile Developer",
      type: "Video Call",
      dateTime: DateTime(2025, 1, 14, 12, 00),
      price: "28",
      status: "Confirmed",
      timeAgo: ""
    ),
    Session(
      id: "6",
      image: "assets/images/people_images/Mariam Nasser.png",
      name: "Mariam Nasser",
      role: "Data Scientist",
      type: "1:1 Session",
      dateTime: DateTime(2025, 1, 14, 18, 00),
      price: "45",
      status: "Confirmed",
      timeAgo: ""
    ),
  ];

  static List<Session> requestList = [
    Session(
      id: "1",
      image: "assets/images/people_images/Alex Johnson.png",
      name: "Alex Johnson",
      role: "React Development",
      type: "Chat Session",
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

  static List<Session> allList = [
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
      type: "Chat Session",
      dateTime: DateTime.now().add(const Duration(days: 1)),
      price: "30",
      status: "PendingApproval",
      timeAgo: ""
    ),
    Session(
      id: "3",
      image: "assets/images/people_images/Marcus Johnson.png",
      name: "Marcus Johnson",
      role: "Mentor",
      type: "Chat Session",
      dateTime: DateTime(2025, 1, 13, 11, 00),
      price: "Free",
      status: "Live Now",
      timeAgo: ""
    ),
  ];
  }
