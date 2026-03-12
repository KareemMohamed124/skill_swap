import 'package:skill_swap/shared/data/models/user/Block_info.dart';
import 'package:skill_swap/shared/data/models/user/profile_model.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';
import 'package:skill_swap/shared/data/models/user/track_model.dart';
import 'package:skill_swap/shared/data/models/user/usesr_image.dart';
import 'package:skill_swap/shared/data/models/user/warnning_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final bool confirmEmail;
  final int warningCount;

  final UserImage userImage;
  final Profile profile;
  final BlockInfo blockInfo;
  final Track track;
  final List<Skill> skills;
  final List<WarningModel> warnings;
  final int rate;
  final int freeHours;
  final int helpTotalHours;
  final int wallet;
  final int totalScore;
  final int numberOfReviews;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.isActive,
      required this.confirmEmail,
      required this.warningCount,
      required this.userImage,
      required this.profile,
      required this.blockInfo,
      required this.track,
      required this.skills,
      required this.warnings,
      required this.rate,
      required this.freeHours,
      required this.helpTotalHours,
      required this.wallet,
      required this.totalScore,
      required this.numberOfReviews});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return UserModel(
      id: json?['_id'] ?? '',
      name: json?['name'] ?? '',
      email: json?['email'] ?? '',
      role: json?['role'] ?? '',
      isActive: json?['isActive'] ?? false,
      confirmEmail: json?['confirmEmail'] ?? false,
      warningCount: parseInt(json?['warningCount']),
      userImage: UserImage.fromJson(json?['userImage']),
      profile: Profile.fromJson(json?['profile']),
      blockInfo: BlockInfo.fromJson(json?['blockInfo']),
      track: Track.fromJson(json?['track']),
      skills: (json?['skills'] as List? ?? [])
          .map((e) => Skill.fromJson(e))
          .toList(),
      warnings: (json?['warnings'] as List? ?? [])
          .map((e) => WarningModel.fromJson(e))
          .toList(),
      rate: parseInt(json?['rate']),
      freeHours: parseInt(json?['freeHours']),
      helpTotalHours: parseInt(json?['helpTotalHours']),
      wallet: parseInt(json?['wallet']),
      totalScore: parseInt(json?['totalScore']),
      numberOfReviews: parseInt(json?['numberOfReviews']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "role": role,
      "isActive": isActive,
      "confirmEmail": confirmEmail,
      "warningCount": warningCount,
      "userImage": userImage.toJson(),
      "profile": profile.toJson(),
      "blockInfo": blockInfo.toJson(),
      "track": track.toJson(),
      "skills": skills.map((e) => e.toJson()).toList(),
      "warnings": warnings.map((e) => e.toJson()).toList(),
      "rate": rate,
      "freeHours": freeHours,
      "helpTotalHours": helpTotalHours,
    };
  }
}
