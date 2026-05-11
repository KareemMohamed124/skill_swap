import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

class ProfileResponse {
  final String message;
<<<<<<< HEAD
  final MyProfile? user;

  ProfileResponse({required this.message, this.user});
=======
  final MyProfile user;

  ProfileResponse({required this.message, required this.user});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'] ?? '',
<<<<<<< HEAD
      user: json['user'] != null ? MyProfile.fromJson(json['user']) : null,
    );
  }

// Map<String, dynamic> toJson() {
//   return {
//     'message': message,
//     'user': user.toJson(),
//   };
// }
=======
      user: MyProfile.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
