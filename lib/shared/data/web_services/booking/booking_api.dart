import 'package:dio/dio.dart';
import 'package:retrofit/http.dart' as retrofit;

import '../../models/booking/booking_request.dart';
import '../../models/status_booking/status_booking_request.dart';
import '../../models/update_booking/update_booking_request.dart';

part 'booking_api.g.dart';

@retrofit.RestApi(baseUrl: "https://skill-swaapp.vercel.app/")
abstract class BookingApi {
  factory BookingApi(Dio dio, {String baseUrl}) = _BookingApi;

  @retrofit.POST("booking/")
  Future<Map<String, dynamic>> bookSession(
    @retrofit.Body() BookingRequest body,
  );

  @retrofit.PATCH("booking/{id}/changeStatus")
  Future<Map<String, dynamic>> statusBookSession(
    @retrofit.Path("id") String id,
    @retrofit.Body() StatusBookingRequest body,
  );

  @retrofit.PATCH("booking/{id}/cancel")
  Future<Map<String, dynamic>> cancelBookSession(
    @retrofit.Path("id") String id,
  );

  @retrofit.PATCH("booking/{id}")
  Future<Map<String, dynamic>> updateBookSession(
    @retrofit.Path("id") String id,
    @retrofit.Body() UpdateBookingRequest body,
  );

  @retrofit.GET("booking")
  @retrofit.Headers({
    "Authorization":
        "skill-swap eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ODc4ZWZmZTMzNWMxNzhhZTllZGRhMSIsInJvbGUiOiJBZG1pbiIsImVtYWlsIjoiY2F0eS1lbWlsQGdtYWlsLmNvbSIsImlhdCI6MTc3MTY5NjE2MywiZXhwIjoxNzcxNzgyNTYzfQ.64Ua4mZD7y-PxiiidrTAu07d9hJhl5l3ZFVDoIDD3Po",
  })
  Future<Map<String, dynamic>> getAllBookings();
}
