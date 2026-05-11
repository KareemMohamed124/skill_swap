part of 'status_book_bloc.dart';

@immutable
sealed class StatusBookEvent {}

class StatusBookSession extends StatusBookEvent {
  final String id;
  final StatusBookingRequest request;
<<<<<<< HEAD
  final String? studentId;

  StatusBookSession({
    required this.id,
    required this.request,
    this.studentId,
  });
=======

  StatusBookSession({required this.id, required this.request});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
