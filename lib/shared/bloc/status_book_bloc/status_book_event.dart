part of 'status_book_bloc.dart';

@immutable
sealed class StatusBookEvent {}

class StatusBookSession extends StatusBookEvent {
  final String id;
  final StatusBookingRequest request;

  StatusBookSession({required this.id, required this.request});
}
