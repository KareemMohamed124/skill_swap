import 'package:json_annotation/json_annotation.dart';

part 'pay_booking_request.g.dart';

<<<<<<< HEAD
@JsonSerializable(includeIfNull: false)
class PayBookingRequest {
  final String successUrl;
  final String cancelUrl;
  final String? voucherId;

  PayBookingRequest(
      {required this.successUrl, required this.cancelUrl, this.voucherId});
=======
@JsonSerializable()
class PayBookingRequest {
  final String successUrl;
  final String cancelUrl;

  PayBookingRequest({
    required this.successUrl,
    required this.cancelUrl,
  });
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  Map<String, dynamic> toJson() => _$PayBookingRequestToJson(this);
}
