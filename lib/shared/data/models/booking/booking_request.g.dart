// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) =>
    BookingRequest(
      time: json['time'] as String,
      date: json['date'] as String,
<<<<<<< HEAD
      duration_mins: json['duration_mins'] as num,
      instructorId: json['instructorId'] as String,
      isFree: json['isFree'] as bool,
=======
      duration_mins: (json['duration_mins'] as num).toInt(),
      instructorId: json['instructorId'] as String,
      price: (json['price'] as num).toInt(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    );

Map<String, dynamic> _$BookingRequestToJson(BookingRequest instance) =>
    <String, dynamic>{
      'instructorId': instance.instructorId,
      'time': instance.time,
      'date': instance.date,
      'duration_mins': instance.duration_mins,
<<<<<<< HEAD
      'isFree': instance.isFree,
=======
      'price': instance.price,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    };
