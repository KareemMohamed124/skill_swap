import 'package:skill_swap/shared/data/models/user/user_model.dart';

class UsersData {
  final List<UserModel> users;
  final int total;

  UsersData({
    required this.users,
    required this.total,
  });

  factory UsersData.fromJson(Map<String, dynamic>? json) {
    return UsersData(
      users: (json?['users'] as List? ?? [])
          .map((e) => UserModel.fromJson(e))
          .toList(),
      total: json?['total'] ?? 0,
    );
  }
}
