import '../booking/booking_model.dart';

class GetBookingsResponse {
  final String message;
  final List<Booking> bookings;

  GetBookingsResponse({
    required this.message,
    required this.bookings,
  });

  factory GetBookingsResponse.fromJson(Map<String, dynamic> json) {
    return GetBookingsResponse(
      message: json['message'],
      bookings:
          (json['bookings'] as List).map((e) => Booking.fromJson(e)).toList(),
    );
  }
}
