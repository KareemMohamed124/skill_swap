// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sendcode_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendCodeErrorResponse _$SendCodeErrorResponseFromJson(
        Map<String, dynamic> json) =>
    SendCodeErrorResponse(
      message: json['message'] as String,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) =>
              SendCodeValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SendCodeErrorResponseToJson(
        SendCodeErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'validationErrors': instance.validationErrors,
    };
