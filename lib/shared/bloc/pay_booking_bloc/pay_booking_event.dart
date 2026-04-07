part of 'pay_booking_bloc.dart';

@immutable
sealed class PayBookingEvent {}

class PayBookingRequested extends PayBookingEvent {
  final String bookingId;

  PayBookingRequested({required this.bookingId});
}
