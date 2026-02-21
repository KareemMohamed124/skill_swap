class UpdateSkill {
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      //'experienceLevel': experienceLevel,
    };
  }
}
