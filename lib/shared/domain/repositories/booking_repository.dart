import '../../data/models/booking/booking_request.dart';
import '../../data/models/booking/booking_response.dart';
import '../../data/models/cancel_booking/cancel_booking_response.dart';
import '../../data/models/status_booking/status_booking_request.dart';
import '../../data/models/status_booking/status_booking_response.dart';
import '../../data/models/update_booking/update_booking_request.dart';
import '../../data/models/update_booking/update_booking_response.dart';

abstract class BookingRepository {
  Future<BookingResponse> bookSession(BookingRequest request);

  Future<StatusBookingResponse> statusBookSession(
      String id, StatusBookingRequest request);

  Future<CancelBookingResponse> cancelBookSession(String id);

  Future<UpdateBookingResponse> updateBookSession(
      String id, UpdateBookingRequest request);

// Future<GetBookingsResponse> getAllBookings();
}
