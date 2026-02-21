import 'package:json_annotation/json_annotation.dart';

part 'booking_request.g.dart';

@JsonSerializable()
class BookingRequest {
  final String userId;
  final String time;
  final String date;
  final int duration_mins;
  final int price;

  BookingRequest(
      {required this.time,
      required this.date,
      required this.duration_mins,
      required this.userId,
      required this.price});

  Map<String, dynamic> toJson() => _$BookingRequestToJson(this);
}
