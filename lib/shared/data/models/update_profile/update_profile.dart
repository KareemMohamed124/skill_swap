class UpdateProfile {
  final String? bio;

<<<<<<< HEAD
  UpdateProfile({this.bio});

  factory UpdateProfile.fromJson(Map<String, dynamic>? json) {
    return UpdateProfile(
      bio: json?['bio']?.toString(),
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
<<<<<<< HEAD

    if (bio != null && bio!.trim().isNotEmpty) {
      data['bio'] = bio;
    }

=======
    if (bio != null) data['bio'] = bio;
    //if (skillSummary != null) data['skillSummary'] = skillSummary;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    return data;
  }
}
