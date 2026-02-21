import 'package:dio/dio.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../models/booking/booking_error_response.dart';
import '../models/booking/booking_request.dart';
import '../models/booking/booking_response.dart';
import '../models/booking/booking_success_response.dart';
import '../models/cancel_booking/cancel_booking_error_response.dart';
import '../models/cancel_booking/cancel_booking_response.dart';
import '../models/cancel_booking/cancel_booking_success_response.dart';
import '../models/status_booking/status_booking_error_response.dart';
import '../models/status_booking/status_booking_request.dart';
import '../models/status_booking/status_booking_response.dart';
import '../models/status_booking/status_booking_success_response.dart';
import '../models/update_booking/update_booking_error_response.dart';
import '../models/update_booking/update_booking_request.dart';
import '../models/update_booking/update_booking_response.dart';
import '../models/update_booking/update_booking_success_response.dart';
import '../web_services/booking/booking_api.dart';

class BookingRepositoryImpl extends BookingRepository {
  final BookingApi api;
  final Dio dio;

  BookingRepositoryImpl({required this.api, required this.dio});

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<BookingResponse> bookSession(BookingRequest request) async {
    try {
      final response = await api.bookSession(request);

      // بما إن response = Map<String,dynamic>
      if (response['message'] == 'Booking created successfully') {
        return BookingSuccess(
          BookingSuccessResponse.fromJson(response),
        );
      }

      return BookingFailure(
        BookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = BookingErrorResponse.fromJson(e.response!.data);
        return BookingFailure(error);
      }

      return BookingFailure(
        BookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return BookingFailure(
        BookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<StatusBookingResponse> statusBookSession(
      String id, StatusBookingRequest request) async {
    try {
      final response = await api.statusBookSession(id, request);

      if (response['message'] == 'Booking status updated') {
        return StatusBookingSuccess(
          StatusBookingSuccessResponse.fromJson(response),
        );
      }

      return StatusBookingFailure(
        StatusBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = StatusBookingErrorResponse.fromJson(e.response!.data);
        return StatusBookingFailure(error);
      }

      return StatusBookingFailure(
        StatusBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return StatusBookingFailure(
        StatusBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<CancelBookingResponse> cancelBookSession(String id) async {
    try {
      final response = await api.cancelBookSession(id);

      if (response['message'] == 'Booking cancelled') {
        return CancelBookingSuccess(
          CancelBookingSuccessResponse.fromJson(response),
        );
      }

      return CancelBookingFailure(
        CancelBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = CancelBookingErrorResponse.fromJson(e.response!.data);
        return CancelBookingFailure(error);
      }

      return CancelBookingFailure(
        CancelBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return CancelBookingFailure(
        CancelBookingErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<UpdateBookingResponse> updateBookSession(
      String id, UpdateBookingRequest request) async {
    try {
      final response = await api.updateBookSession(id, request);

      if (response['message'] == 'Booking updated') {
        return UpdateBookingSuccess(
          UpdateBookingSuccessResponse.fromJson(response),
        );
      }

      return UpdateBookingFailure(
        UpdateBookingErrorResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = UpdateBookingErrorResponse.fromJson(e.response!.data);
        return UpdateBookingFailure(error);
      }

      return UpdateBookingFailure(
        UpdateBookingErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return UpdateBookingFailure(
        UpdateBookingErrorResponse(message: e.toString()),
      );
    }
  }

// @override
// Future<GetBookingsResponse> getAllBookings() async {
//   final response = await api.getAllBookings();
//   return response
//   .;
//  }
}
