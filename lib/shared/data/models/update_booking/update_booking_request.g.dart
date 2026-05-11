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
<<<<<<< HEAD
      duration_mins: json['duration_mins'] as num,
=======
      duration_mins: (json['duration_mins'] as num).toInt(),
      price: (json['price'] as num).toInt(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );

Map<String, dynamic> _$UpdateBookingRequestToJson(
        UpdateBookingRequest instance) =>
    <String, dynamic>{
      'time': instance.time,
      'date': instance.date,
      'duration_mins': instance.duration_mins,
<<<<<<< HEAD
=======
      'price': instance.price,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    };
