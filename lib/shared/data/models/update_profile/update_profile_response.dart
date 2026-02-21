import '../my_profile/my_profile.dart';

sealed class UpdateProfileResponse {
  final String message;

  const UpdateProfileResponse(this.message);
}

class UpdateProfileData extends UpdateProfileResponse {
  final MyProfile user;

  const UpdateProfileData({
    required String message,
    required this.user,
  }) : super(message);

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      message: json['message'] ?? '',
      user: MyProfile.fromJson(json['user']),
    );
  }
}

class UpdateProfileFailure extends UpdateProfileResponse {
  const UpdateProfileFailure({required String error}) : super(error);
}