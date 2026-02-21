part of 'book_session_bloc.dart';

@immutable
sealed class BookSessionState {}

final class BookSessionInitial extends BookSessionState {}

final class BookSessionLoading extends BookSessionState {}

final class BookSessionSuccess extends BookSessionState {
  final BookingSuccess success;

  BookSessionSuccess({required this.success});
}

final class BookSessionFailure extends BookSessionState {
  final BookingFailure error;

  BookSessionFailure({required this.error});
}
