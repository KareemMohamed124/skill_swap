class Profile {
  final String bio;
  final String skillSummary;
  final int reputationScore;
  final String location;
  final String lastUpdated;

  Profile({
    required this.bio,
    required this.skillSummary,
    required this.reputationScore,
    required this.location,
    required this.lastUpdated,
  });

  factory Profile.fromJson(Map<String, dynamic>? json) {
    return Profile(
      bio: json?['bio'] ?? '',
      skillSummary: json?['skillSummary'] ?? '',
      reputationScore: json?['reputationScore'] ?? 0,
      location: json?['location'] ?? '',
      lastUpdated: json?['lastUpdated'] ?? '',
    );
  }

  factory Profile.empty() {
    return Profile(
        bio: "",
        skillSummary: "",
        reputationScore: 0,
        location: "",
        lastUpdated: "");
  }
}
