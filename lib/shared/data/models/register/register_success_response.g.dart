// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterSuccessResponse _$RegisterSuccessResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterSuccessResponse(
      message: json['message'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$RegisterSuccessResponseToJson(
        RegisterSuccessResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      '_id': instance.id,
    };
