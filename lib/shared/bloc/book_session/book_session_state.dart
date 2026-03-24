import '../../data/models/booking/booking_model.dart';

sealed class ActiveBookingState {}

class BookingIdle extends ActiveBookingState {} // مفيش أي booking

class BookingLoading extends ActiveBookingState {} // loading لأي عملية

class BookingLoaded extends ActiveBookingState {
  final Booking booking;

  BookingLoaded(this.booking);
}

class BookingError extends ActiveBookingState {
  final String message;

  BookingError(this.message);
}

class BookingCreatedSuccess extends ActiveBookingState {
  final Booking booking;

  BookingCreatedSuccess(this.booking);
}
