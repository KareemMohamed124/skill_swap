// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) =>
    BookingRequest(
      time: json['time'] as String,
      date: json['date'] as String,
      duration_mins: (json['duration_mins'] as num).toInt(),
      userId: json['userId'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$BookingRequestToJson(BookingRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'time': instance.time,
      'date': instance.date,
      'duration_mins': instance.duration_mins,
      'price': instance.price,
    };
