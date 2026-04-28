import 'package:equatable/equatable.dart';
import 'package:skill_swap/shared/data/models/my_profile/Blocked_me.dart';

import '../user/profile_model.dart';
import '../user/skill_model.dart';
import '../user/track_model.dart';
import '../user/usesr_image.dart';
import 'active_theme.dart';
import 'review_model.dart';

class MyProfile extends Equatable {
  final UserImage userImage;
  final Profile profile;
  final BlockedMe blockInfo;
  final Track track;

  final String id;
  final String name;
  final String email;

  final bool isActive;
  final String role;

  final ActiveTheme? activeTheme;
  final int rate;
  final int totalScore;
  final int wallet;
  final int numberOfReviews;
  final String? activationCode;
  final DateTime? activationCodeExpires;
  final String fcmToken;
  final int score;

  final int varPoints;
  final int points;

  final int freeHours;
  final int helpTotalHours;

  final int warningCount;
  final int v;

  final List<Skill> skills;
  final List<ReviewModel> reviews;

  final List<dynamic> messages;
  final List<dynamic> reports;
  final List<dynamic> requests;
  final List<dynamic> feedbackGiven;
  final List<dynamic> feedbackReceived;
  final List<dynamic> mentorSuggestions;
  final List<dynamic> challenges;
  final List<dynamic> warnings;
  final List<dynamic> purchasedThemes;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MyProfile({
    required this.userImage,
    required this.profile,
    required this.blockInfo,
    required this.track,
    required this.id,
    required this.name,
    required this.varPoints,
    required this.email,
    required this.isActive,
    required this.role,
    required this.rate,
    required this.totalScore,
    required this.wallet,
    required this.numberOfReviews,
    required this.freeHours,
    required this.helpTotalHours,
    required this.warningCount,
    required this.v,
    required this.activationCode,
    required this.activationCodeExpires,
    required this.fcmToken,
    required this.score,
    required this.points,
    required this.skills,
    required this.reviews,
    required this.messages,
    required this.reports,
    required this.requests,
    required this.activeTheme,
    required this.feedbackGiven,
    required this.feedbackReceived,
    required this.mentorSuggestions,
    required this.challenges,
    required this.warnings,
    required this.purchasedThemes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return MyProfile(
      userImage: json['userImage'] != null
          ? UserImage.fromJson(json['userImage'])
          : UserImage.empty(),
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'])
          : Profile.empty(),
      track:
          json['track'] != null ? Track.fromJson(json['track']) : Track.empty(),
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
      activationCode: json['activationCode'],
      activeTheme: json['activeTheme'] != null && json['activeTheme'] is Map
          ? ActiveTheme.fromJson(json['activeTheme'])
          : null,
      activationCodeExpires: json['activationCodeExpires'] != null
          ? DateTime.tryParse(json['activationCodeExpires'])
          : null,
      fcmToken: json['fcmToken'] ?? '',
      score: parseInt(json['score']),
      varPoints: parseInt(json['var_points']),
      points: parseInt(json['points']),
      messages: json['messages'] ?? [],
      purchasedThemes: json['purchasedThemes'] ?? [],
      reports: json['reports'] ?? [],
      requests: json['requests'] ?? [],
      feedbackGiven: json['feedbackGiven'] ?? [],
      feedbackReceived: json['feedbackReceived'] ?? [],
      mentorSuggestions: json['mentorSuggestions'] ?? [],
      skills: json['skills'] != null
          ? (json['skills'] as List)
              .map((x) => x is Map<String, dynamic>
                  ? Skill.fromJson(x)
                  : Skill(
                      skillName: x.toString(),
                      isVerified: false,
                      id: '',
                      quizScore: 0,
                      addedAt: '',
                    ))
              .toList()
          : [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      v: json['__v'] ?? 0,
      warningCount: parseInt(json['warningCount']) ?? 0,
      warnings: json['warnings'] ?? [],
      rate: parseInt(json['rate']) ?? 0,
      totalScore: parseInt(json['totalScore']) ?? 0,
      wallet: parseInt(json['wallet']) ?? 0,
      numberOfReviews: parseInt(json['numberOfReviews']) ?? 0,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((x) => ReviewModel.fromJson(x))
              .toList()
          : [],
      challenges: json['challenges'] ?? [],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'userImage': userImage.toJson(),
  //     'profile': profile.toJson(),
  //     'blockInfo': blockInfo.toJson(),
  //     'track': track.toJson(),
  //     '_id': id,
  //     'name': name,
  //     'email': email,
  //     'isActive': isActive,
  //     'role': role,
  //     'freeHours': freeHours,
  //     'helpTotalHours': helpTotalHours,
  //     'messages': messages,
  //     'reports': reports,
  //     'requests': requests,
  //     'feedbackGiven': feedbackGiven,
  //     'feedbackReceived': feedbackReceived,
  //     'mentorSuggestions': mentorSuggestions,
  //     'skills': skills.map((e) => e.toJson()).toList(),
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //     '__v': v,
  //     'warningCount': warningCount,
  //     'warnings': warnings,
  //   };
  // }

  @override
  List<Object?> get props => [
        userImage,
        profile,
        blockInfo,
        track,
        id,
        name,
        email,
        isActive,
        purchasedThemes,
        role,
        rate,
        totalScore,
        wallet,
        activationCode,
        activationCodeExpires,
        fcmToken,
        score,
        varPoints,
        numberOfReviews,
        activeTheme,
        freeHours,
        helpTotalHours,
        warningCount,
        v,
        skills,
        reviews,
        messages,
        reports,
        requests,
        feedbackGiven,
        feedbackReceived,
        mentorSuggestions,
        challenges,
        warnings,
        createdAt,
        updatedAt,
      ];
}
