import 'package:skill_swap/shared/data/models/my_profile/Blocked_me.dart';

import '../user/profile_model.dart';
import '../user/skill_model.dart';
import '../user/usesr_image.dart';

class MyProfile {
  final UserImage userImage;
  final Profile profile;
  final BlockedMe blockInfo;
  final String id;
  final String name;
  final String email;
  final bool isActive;
  final String role;
  final int freeHours;
  final int helpTotalHours;
  final List<dynamic> messages;
  final List<dynamic> reports;
  final List<dynamic> requests;
  final List<dynamic> feedbackGiven;
  final List<dynamic> feedbackReceived;
  final List<dynamic> mentorSuggestions;
  final List<Skill> skills;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final int warningCount;
  final List<dynamic> warnings;

  MyProfile({
    required this.userImage,
    required this.profile,
    required this.blockInfo,
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.role,
    required this.freeHours,
    required this.helpTotalHours,
    required this.messages,
    required this.reports,
    required this.requests,
    required this.feedbackGiven,
    required this.feedbackReceived,
    required this.mentorSuggestions,
    required this.skills,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.warningCount,
    required this.warnings,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    return MyProfile(
      userImage: json['userImage'] != null
          ? UserImage.fromJson(json['userImage'])
          : UserImage.empty(),
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'])
          : Profile.empty(),
      blockInfo: json['blockInfo'] != null
          ? BlockedMe.fromJson(json['blockInfo'])
          : BlockedMe.empty(),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
      role: json['role'] ?? '',
      freeHours: json['freeHours'] ?? 0,
      helpTotalHours: json['helpTotalHours'] ?? 0,
      messages: json['messages'] ?? [],
      reports: json['reports'] ?? [],
      requests: json['requests'] ?? [],
      feedbackGiven: json['feedbackGiven'] ?? [],
      feedbackReceived: json['feedbackReceived'] ?? [],
      mentorSuggestions: json['mentorSuggestions'] ?? [],
      skills: json['skills'] != null
          ? List<Skill>.from(
              json['skills'].map((x) => Skill.fromJson(x)),
            )
          : [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      warningCount: json['warningCount'] ?? 0,
      warnings: json['warnings'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userImage': userImage,
      'profile': profile,
      'blockInfo': blockInfo.toJson(),
      '_id': id,
      'name': name,
      'email': email,
      'isActive': isActive,
      'role': role,
      'freeHours': freeHours,
      'helpTotalHours': helpTotalHours,
      'messages': messages,
      'reports': reports,
      'requests': requests,
      'feedbackGiven': feedbackGiven,
      'feedbackReceived': feedbackReceived,
      'mentorSuggestions': mentorSuggestions,
      'skills': skills,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'warningCount': warningCount,
      'warnings': warnings,
    };
  }
}
