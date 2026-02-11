import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String email;

  final bool isActive;
  final String role;
  final int freeHours;
  final int helpTotalHours;

  final List<dynamic> messages;

  final String? location;
  final DateTime? lastUpdated;

  // ====== Local only (NOT from API) ======
  @JsonKey(ignore: true)
  String? bio;

  @JsonKey(ignore: true)
  String? skills;

  @JsonKey(ignore: true)
  String? imagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.role,
    required this.freeHours,
    required this.helpTotalHours,
    required this.messages,
    this.location,
    this.lastUpdated,
    this.bio,
    this.skills,
    this.imagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? name,
    String? email,
    bool? isActive,
    String? role,
    int? freeHours,
    int? helpTotalHours,
    List<dynamic>? messages,
    String? location,
    DateTime? lastUpdated,
    String? bio,
    String? skills,
    String? imagePath,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      freeHours: freeHours ?? this.freeHours,
      helpTotalHours: helpTotalHours ?? this.helpTotalHours,
      messages: messages ?? this.messages,
      location: location ?? this.location,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
