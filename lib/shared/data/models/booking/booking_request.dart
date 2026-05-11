import 'package:json_annotation/json_annotation.dart';

part 'booking_request.g.dart';

@JsonSerializable()
class BookingRequest {
  final String instructorId;
  final String time;
  final String date;
<<<<<<< HEAD
  final num duration_mins;
  final bool isFree;
=======
  final int duration_mins;
  final int price;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  BookingRequest(
      {required this.time,
      required this.date,
      required this.duration_mins,
      required this.instructorId,
<<<<<<< HEAD
      required this.isFree});
=======
      required this.price});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  Map<String, dynamic> toJson() => _$BookingRequestToJson(this);
}
