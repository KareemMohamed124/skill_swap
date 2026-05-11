import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final String skillName;
  final bool isVerified;
<<<<<<< HEAD
  final int quizScore;
  final String id;
  final String addedAt;
=======
  final int badgeLevel;
  final int quizScore;
  final String experienceLevel;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  Skill({
    required this.skillName,
    required this.isVerified,
<<<<<<< HEAD
    required this.id,
    required this.quizScore,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [skillName, isVerified, id, quizScore, addedAt];
=======
    required this.badgeLevel,
    required this.quizScore,
    required this.experienceLevel,
  });

  @override
  List<Object?> get props =>
      [skillName, isVerified, badgeLevel, quizScore, experienceLevel];
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  factory Skill.fromJson(Map<String, dynamic>? json) {
    return Skill(
      skillName: json?['skillName'] ?? '',
      isVerified: json?['isVerified'] ?? false,
<<<<<<< HEAD
      id: json?['_id'] ?? "",
      quizScore: json?['quizScore'] ?? 0,
      addedAt: json?['addedAt'] ?? '',
=======
      badgeLevel: json?['badgeLevel'] ?? 0,
      quizScore: json?['quizScore'] ?? 0,
      experienceLevel: json?['experienceLevel'] ?? '',
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'isVerified': isVerified,
<<<<<<< HEAD
      '_id': id,
      'quizScore': quizScore,
      'addedAt': addedAt,
=======
      'badgeLevel': badgeLevel,
      'quizScore': quizScore,
      'experienceLevel': experienceLevel,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    };
  }
}
