import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../models/booking/booking_request.dart';
import '../../models/status_booking/status_booking_request.dart';
import '../../models/update_booking/update_booking_request.dart';

part 'booking_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/")
abstract class BookingApi {
  factory BookingApi(Dio dio, {String baseUrl}) = _BookingApi;

  @POST("booking/")
  Future<dynamic> bookSession(
    @Body() BookingRequest body,
  );

  @PATCH("booking/{id}/changeStatus")
  Future<dynamic> statusBookSession(
    @Path("id") String id,
    @Body() StatusBookingRequest body,
  );

  @PATCH("booking/{id}/cancel")
  Future<dynamic> cancelBookSession(
    @Path("id") String id,
  );

  @PATCH("booking/{id}")
  Future<dynamic> updateBookSession(
    @Path("id") String id,
    @Body() UpdateBookingRequest body,
  );

  @DELETE("booking/{id}")
  Future<dynamic> deleteBookSession(
    @Path("id") String id,
  );

  @GET("booking/{id}")
  Future<dynamic> getBookingDetails(
    @Path("id") String id,
  );

  @GET("booking")
  @Headers({
    "Authorization":
        "skill-swap eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ODc4ZWZmZTMzNWMxNzhhZTllZGRhMSIsInJvbGUiOiJBZG1pbiIsImVtYWlsIjoiY2F0eS1lbWlsQGdtYWlsLmNvbSIsImlhdCI6MTc3MTY5NjE2MywiZXhwIjoxNzcxNzgyNTYzfQ.64Ua4mZD7y-PxiiidrTAu07d9hJhl5l3ZFVDoIDD3Po",
  })
  Future<dynamic> getAllBookings();
}
