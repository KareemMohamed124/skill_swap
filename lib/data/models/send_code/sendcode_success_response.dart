import 'package:json_annotation/json_annotation.dart';

part 'sendcode_success_response.g.dart';

@JsonSerializable()
class SendCodeSuccessResponse {
  final String message;

  SendCodeSuccessResponse({required this.message});

  factory SendCodeSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SendCodeSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendCodeSuccessResponseToJson(this);
}
