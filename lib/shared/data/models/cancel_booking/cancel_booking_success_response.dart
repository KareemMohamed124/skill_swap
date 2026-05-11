import 'package:json_annotation/json_annotation.dart';

part 'cancel_booking_success_response.g.dart';

@JsonSerializable()
class CancelBookingSuccessResponse {
  final String message;

<<<<<<< HEAD
  // @JsonKey(name: 'booking')
=======
  // @JsonKey(name: 'booking') // ← أهم سطر
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  // final Booking bookSession;

  CancelBookingSuccessResponse({
    required this.message,
    //required this.bookSession,
  });

  factory CancelBookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CancelBookingSuccessResponseToJson(this);
}
