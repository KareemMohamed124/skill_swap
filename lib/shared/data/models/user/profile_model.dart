import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String bio;
  final String skillSummary;
  final int reputationScore;
<<<<<<< HEAD
=======
  final String location;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final String lastUpdated;

  Profile({
    required this.bio,
    required this.skillSummary,
    required this.reputationScore,
<<<<<<< HEAD
=======
    required this.location,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        bio,
        skillSummary,
        reputationScore,
<<<<<<< HEAD
=======
        location,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        lastUpdated,
      ];

  factory Profile.fromJson(Map<String, dynamic>? json) {
    return Profile(
      bio: json?['bio'] ?? '',
      skillSummary: json?['skillSummary'] ?? '',
      reputationScore: json?['reputationScore'] ?? 0,
<<<<<<< HEAD
=======
      location: json?['location'] ?? '',
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      lastUpdated: json?['lastUpdated'] ?? '',
    );
  }

  factory Profile.empty() {
    return Profile(
<<<<<<< HEAD
        bio: "", skillSummary: "", reputationScore: 0, lastUpdated: "");
=======
        bio: "",
        skillSummary: "",
        reputationScore: 0,
        location: "",
        lastUpdated: "");
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'skillSummary': skillSummary,
      'reputationScore': reputationScore,
<<<<<<< HEAD
=======
      'location': location,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      'lastUpdated': lastUpdated
    };
  }
}
