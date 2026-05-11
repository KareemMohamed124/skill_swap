import 'package:skill_swap/shared/data/models/update_profile/update_profile.dart';
import 'package:skill_swap/shared/data/models/update_profile/update_skill.dart';

class UpdateProfileRequest {
  final String? name;
  final UpdateProfile? profile;
  final List<UpdateSkill>? skills;

  UpdateProfileRequest({
    this.name,
    this.profile,
    this.skills,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
<<<<<<< HEAD
      name: json['name']?.toString(),
=======
      name: json['name'],
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      profile: json['profile'] != null
          ? UpdateProfile.fromJson(json['profile'])
          : null,
      skills: json['skills'] != null
          ? (json['skills'] as List)
<<<<<<< HEAD
          .map((e) => UpdateSkill.fromJson(e))
          .toList()
=======
              .map((e) => UpdateSkill.fromJson(e))
              .toList()
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

<<<<<<< HEAD
    if (name != null && name!.isNotEmpty) {
      data['name'] = name;
    }

    if (profile != null) {
      final profileJson = profile!.toJson();
      if (profileJson.isNotEmpty) {
        data['profile'] = profileJson;
      }
    }

    if (skills != null && skills!.isNotEmpty) {
=======
    if (name != null) data['name'] = name;
    if (profile != null) data['profile'] = profile!.toJson();

    if (skills != null) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      data['skills'] = skills!.map((e) => e.toJson()).toList();
    }

    return data;
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
