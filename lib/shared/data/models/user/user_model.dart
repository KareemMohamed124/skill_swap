import 'package:skill_swap/shared/data/models/user/Block_info.dart';
import 'package:skill_swap/shared/data/models/user/profile_model.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';
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

  final List<Skill> skills;
  final List<WarningModel> warnings;
  final int rate;
  final int freeHours;
  final int helpTotalHours;

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
      required this.skills,
      required this.warnings,
      required this.rate,
      required this.freeHours,
      required this.helpTotalHours});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
        id: json?['_id'] ?? '',
        name: json?['name'] ?? '',
        email: json?['email'] ?? '',
        role: json?['role'] ?? '',
        isActive: json?['isActive'] ?? false,
        confirmEmail: json?['confirmEmail'] ?? false,
        warningCount: json?['warningCount'] ?? 0,
        userImage: UserImage.fromJson(json?['userImage']),
        profile: Profile.fromJson(json?['profile']),
        blockInfo: BlockInfo.fromJson(json?['blockInfo']),
        skills: (json?['skills'] as List? ?? [])
            .map((e) => Skill.fromJson(e))
            .toList(),
        warnings: (json?['warnings'] as List? ?? [])
            .map((e) => WarningModel.fromJson(e))
            .toList(),
        rate: json?['rate'] ?? 0,
        freeHours: json?['freeHours'] ?? 0,
        helpTotalHours: json?['helpTotalHours'] ?? 0);
  }
}
