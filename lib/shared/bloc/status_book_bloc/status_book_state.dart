part of 'status_book_bloc.dart';

@immutable
abstract class StatusBookState {}

class StatusBookInitial extends StatusBookState {}

class StatusBookLoadingForSession extends StatusBookState {
  final String id;

  StatusBookLoadingForSession({required this.id});
}

class StatusBookSuccess extends StatusBookState {
  final StatusBookingSuccess success;
  final String sessionId;

  StatusBookSuccess({required this.success, required this.sessionId});
}

class StatusBookFailure extends StatusBookState {
<<<<<<< HEAD
  final StatusBookingErrorResponse error;
=======
  final StatusBookingErrorResponse error; // بدل StatusBookingFailure
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final String sessionId;

  StatusBookFailure({required this.error, required this.sessionId});
}
