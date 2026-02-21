part of 'book_session_bloc.dart';

@immutable
sealed class BookSessionEvent {}

class BookSession extends BookSessionEvent {
  final BookingRequest request;

  BookSession({required this.request});
}
