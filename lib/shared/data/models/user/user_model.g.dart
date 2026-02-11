// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isActive: json['isActive'] as bool,
      role: json['role'] as String,
      freeHours: (json['freeHours'] as num).toInt(),
      helpTotalHours: (json['helpTotalHours'] as num).toInt(),
      messages: json['messages'] as List<dynamic>,
      location: json['location'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'isActive': instance.isActive,
      'role': instance.role,
      'freeHours': instance.freeHours,
      'helpTotalHours': instance.helpTotalHours,
      'messages': instance.messages,
      'location': instance.location,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
