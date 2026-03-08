import '../user/usesr_image.dart';

class UserBooking {
  final String id;
  final String name;
  final String email;
  final UserImage userImage;
  final String role;

  UserBooking(
      {required this.id,
      required this.name,
      required this.email,
      required this.userImage,
      required this.role});

  factory UserBooking.fromJson(Map<String, dynamic> json) {
    return UserBooking(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        userImage: UserImage.fromJson(json['userImage']),
        role: json['role']?.toString() ?? '');
  }
}
