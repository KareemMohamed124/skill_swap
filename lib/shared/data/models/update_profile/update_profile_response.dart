import 'package:skill_swap/shared/data/models/update_profile/update_user.dart';

sealed class UpdateProfileResponse {
  final String message;

  const UpdateProfileResponse(this.message);
}

class UpdateProfileData extends UpdateProfileResponse {
  final UpdateUser user;

  const UpdateProfileData({
    required String message,
    required this.user,
  }) : super(message);

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      message: json['message'] ?? '',
<<<<<<< HEAD
      user: UpdateUser.fromJson(json['user'] ?? {}),
=======
      user: UpdateUser.fromJson(json['user']),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );
  }
}

class UpdateProfileFailure extends UpdateProfileResponse {
  const UpdateProfileFailure({required String error}) : super(error);
}
