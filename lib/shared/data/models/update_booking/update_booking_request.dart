import 'package:json_annotation/json_annotation.dart';

part 'update_booking_request.g.dart';

@JsonSerializable()
class UpdateBookingRequest {
  final String time;
  final String date;
<<<<<<< HEAD
  final num duration_mins;

  UpdateBookingRequest({
    required this.time,
    required this.date,
    required this.duration_mins,
  });
=======
  final int duration_mins;
  final int price;

  UpdateBookingRequest(
      {required this.time,
      required this.date,
      required this.duration_mins,
      required this.price});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  Map<String, dynamic> toJson() => _$UpdateBookingRequestToJson(this);
}
