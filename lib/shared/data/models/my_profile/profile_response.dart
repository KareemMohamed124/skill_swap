import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

class ProfileResponse {
  final String message;
  final MyProfile user;

  ProfileResponse({required this.message, required this.user});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'] ?? '',
      user: MyProfile.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}
