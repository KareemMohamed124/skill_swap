part of 'status_book_bloc.dart';

@immutable
sealed class StatusBookState {}

final class StatusBookInitial extends StatusBookState {}

final class StatusBookLoading extends StatusBookState {}

final class StatusBookSuccess extends StatusBookState {
  final StatusBookingSuccess success;

  StatusBookSuccess({required this.success});
}

final class StatusBookFailure extends StatusBookState {
  final StatusBookingFailure error;

  StatusBookFailure({required this.error});
}
