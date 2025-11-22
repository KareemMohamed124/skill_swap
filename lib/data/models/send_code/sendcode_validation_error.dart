import 'package:json_annotation/json_annotation.dart';

part 'sendcode_validation_error.g.dart';

@JsonSerializable()
class SendCodeValidationError {
  final String field;
  final String message;

  SendCodeValidationError({required this.field, required this.message});

  factory SendCodeValidationError.fromJson(Map<String, dynamic> json) =>
      _$SendCodeValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$SendCodeValidationErrorToJson(this);
}
