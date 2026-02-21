class Skill {
  final String skillName;
  final bool isVerified;
  final int badgeLevel;
  final int quizScore;
  final String experienceLevel;

  Skill({
    required this.skillName,
    required this.isVerified,
    required this.badgeLevel,
    required this.quizScore,
    required this.experienceLevel,
  });

  factory Skill.fromJson(Map<String, dynamic>? json) {
    return Skill(
      skillName: json?['skillName'] ?? '',
      isVerified: json?['isVerified'] ?? false,
      badgeLevel: json?['badgeLevel'] ?? 0,
      quizScore: json?['quizScore'] ?? 0,
      experienceLevel: json?['experienceLevel'] ?? '',
    );
  }
}
