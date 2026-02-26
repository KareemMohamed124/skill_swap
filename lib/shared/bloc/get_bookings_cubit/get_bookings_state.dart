import 'package:equatable/equatable.dart';

import '../../../mobile/presentation/sessions/models/session.dart';

abstract class GetBookingsState extends Equatable {
  const GetBookingsState();

  @override
  List<Object?> get props => [];
}

class GetBookingsInitial extends GetBookingsState {}

class GetBookingsLoading extends GetBookingsState {}

class GetBookingsLoaded extends GetBookingsState {
  final List<SessionModel> bookings;

  const GetBookingsLoaded({required this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class GetBookingsError extends GetBookingsState {
  final String message;

  const GetBookingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
