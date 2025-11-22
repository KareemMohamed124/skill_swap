import 'package:json_annotation/json_annotation.dart';
import 'package:skill_swap/data/models/send_code/sendcode_validation_error.dart';


part 'sendcode_error_response.g.dart';

@JsonSerializable()
class SendCodeErrorResponse {
  final String message;
  final List<SendCodeValidationError>? validationErrors;

  SendCodeErrorResponse({required this.message, this.validationErrors});

  factory SendCodeErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$SendCodeErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendCodeErrorResponseToJson(this);
}
