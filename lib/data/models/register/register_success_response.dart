import 'package:json_annotation/json_annotation.dart';

part 'register_success_response.g.dart';

@JsonSerializable()
class RegisterSuccessResponse {
  final String message;
  @JsonKey(name: "_id")
  final String id;

  RegisterSuccessResponse({required this.message, required this.id});

  factory RegisterSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterSuccessResponseToJson(this);
}
