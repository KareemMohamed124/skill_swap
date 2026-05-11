part of 'pay_booking_bloc.dart';

@immutable
sealed class PayBookingEvent {}

class PayBookingRequested extends PayBookingEvent {
  final String bookingId;
<<<<<<< HEAD
  final String? voucherId;

  PayBookingRequested({required this.bookingId, this.voucherId});
=======

  PayBookingRequested({required this.bookingId});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
