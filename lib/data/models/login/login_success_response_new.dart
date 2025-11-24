import 'package:json_annotation/json_annotation.dart';

part 'login_success_response_new.g.dart';

@JsonSerializable()
class LoginSuccessResponseNew {
  final String message;

  @JsonKey(name: "_id")
  final String id;

  LoginSuccessResponseNew({required this.message, required this.id});

  factory LoginSuccessResponseNew.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessResponseNewFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessResponseNewToJson(this);
}
