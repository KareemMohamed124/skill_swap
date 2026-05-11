import '../../data/models/booking/booking_model.dart';

sealed class ActiveBookingState {}

<<<<<<< HEAD
class BookingIdle extends ActiveBookingState {}

class BookingLoading extends ActiveBookingState {}
=======
class BookingIdle extends ActiveBookingState {} // مفيش أي booking

class BookingLoading extends ActiveBookingState {} // loading لأي عملية
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

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
<<<<<<< HEAD

class BookingUpdatedSuccess extends ActiveBookingState {}

class BookingCancelledSuccess extends ActiveBookingState {}
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
