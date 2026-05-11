class UpdateSkill {
<<<<<<< HEAD
  final String? skillName;

  UpdateSkill({this.skillName});

  factory UpdateSkill.fromJson(Map<String, dynamic>? json) {
    return UpdateSkill(
      skillName: json?['skillName']?.toString(),
=======
  final String skillName;

  // final String experienceLevel;

  UpdateSkill({
    required this.skillName,
    // required this.experienceLevel,
  });

  factory UpdateSkill.fromJson(Map<String, dynamic>? json) {
    return UpdateSkill(
      skillName: json?['skillName'] ?? '',
      // experienceLevel: json?['experienceLevel'] ?? '',
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );
  }

  Map<String, dynamic> toJson() {
<<<<<<< HEAD
    final data = <String, dynamic>{};

    final value = skillName?.trim();
    if (value != null && value.isNotEmpty) {
      data['skillName'] = value;
    }

    return data;
  }
}
=======
    return {
      'skillName': skillName,
      //'experienceLevel': experienceLevel,
    };
  }
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
