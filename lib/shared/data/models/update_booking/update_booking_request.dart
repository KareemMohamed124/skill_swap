import 'package:json_annotation/json_annotation.dart';

part 'update_booking_request.g.dart';

@JsonSerializable()
class UpdateBookingRequest {
  final String time;
  final String date;
  final int duration_mins;
  final int price;

  UpdateBookingRequest(
      {required this.time,
      required this.date,
      required this.duration_mins,
      required this.price});

  Map<String, dynamic> toJson() => _$UpdateBookingRequestToJson(this);
}
