// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBookingRequest _$UpdateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateBookingRequest(
      time: json['time'] as String,
      date: json['date'] as String,
      duration_mins: (json['duration_mins'] as num).toInt(),
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateBookingRequestToJson(
        UpdateBookingRequest instance) =>
    <String, dynamic>{
      'time': instance.time,
      'date': instance.date,
      'duration_mins': instance.duration_mins,
      'price': instance.price,
    };
