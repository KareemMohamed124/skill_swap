import 'package:json_annotation/json_annotation.dart';

part 'pay_booking_request.g.dart';

@JsonSerializable()
class PayBookingRequest {
  final String successUrl;
  final String cancelUrl;

  PayBookingRequest({
    required this.successUrl,
    required this.cancelUrl,
  });

  Map<String, dynamic> toJson() => _$PayBookingRequestToJson(this);
}
