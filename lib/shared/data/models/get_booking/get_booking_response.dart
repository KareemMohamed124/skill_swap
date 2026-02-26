import 'booking.dart';

class GetBookingsResponse {
  final String message;
  final List<GetBookingModel> bookings;

  GetBookingsResponse({
    required this.message,
    required this.bookings,
  });

  factory GetBookingsResponse.fromJson(Map<String, dynamic> json) {
    return GetBookingsResponse(
      message: json['message']?.toString() ?? '',
      bookings: json['bookings'] != null && json['bookings'] is List
          ? (json['bookings'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => GetBookingModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
