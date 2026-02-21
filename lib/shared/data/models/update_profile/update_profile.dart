class UpdateProfile {
  final String? bio;

  //final String? skillSummary;

  //final String location;

  UpdateProfile({
    required this.bio,
    //required this.skillSummary,
    //required this.location,
  });

  factory UpdateProfile.fromJson(Map<String, dynamic>? json) {
    return UpdateProfile(
      bio: json?['bio'] ?? '',
      //skillSummary: json?['skillSummary'] ?? '',
      //location: json?['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (bio != null) data['bio'] = bio;
    //if (skillSummary != null) data['skillSummary'] = skillSummary;
    return data;
  }
}
