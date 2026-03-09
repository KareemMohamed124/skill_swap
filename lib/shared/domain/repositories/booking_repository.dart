import 'package:skill_swap/shared/data/models/join_session/join_session_response.dart';

import '../../data/models/booking/booking_request.dart';
import '../../data/models/booking/booking_response.dart';
import '../../data/models/booking_details/booking_details_response.dart';
import '../../data/models/cancel_booking/cancel_booking_response.dart';
import '../../data/models/delete_booking/delete_booking_response.dart';
import '../../data/models/get_booking/get_booking_response.dart';
import '../../data/models/pay_booking/pay_booking_request.dart';
import '../../data/models/pay_booking/pay_booking_response.dart';
import '../../data/models/status_booking/status_booking_request.dart';
import '../../data/models/status_booking/status_booking_response.dart';
import '../../data/models/submit_review/submit_review_request.dart';
import '../../data/models/submit_review/submit_review_response.dart';
import '../../data/models/update_booking/update_booking_request.dart';
import '../../data/models/update_booking/update_booking_response.dart';

abstract class BookingRepository {
  Future<BookingResponse> bookSession(BookingRequest request);

  Future<StatusBookingResponse> statusBookSession(
      String id, StatusBookingRequest request);

  Future<CancelBookingResponse> cancelBookSession(String id);

  Future<UpdateBookingResponse> updateBookSession(
      String id, UpdateBookingRequest request);

  Future<DeleteBookingResponse> deleteBookSession(String id);

  Future<BookingDetailsResponse> getBookingDetails(String id);

  Future<GetBookingsResponse> getAllBookings(String status);

  Future<PayBookingResponse> payBooking(String id, PayBookingRequest request);

  Future<SubmitReviewResponse> submitReview(
      String id, SubmitReviewRequest body);

  Future<JoinSessionResponse> joinSession(
    String id,
  );
}
