import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/accepted_booking/accepted_bookings_model.dart';
import '../../domain/repositories/booking_repository.dart';

part 'accepted_bookings_state.dart';

class AcceptedBookingsCubit extends Cubit<AcceptedBookingsState> {
  final BookingRepository bookingRepository;

  AcceptedBookingsCubit(this.bookingRepository)
      : super(AcceptedBookingsInitial());

  Future<void> getAcceptedBookings() async {
    emit(AcceptedBookingsLoading());

    try {
      final response = await bookingRepository.getAcceptedBookings();

      emit(AcceptedBookingsLoaded(bookings: response.bookings));
    } catch (e) {
      emit(AcceptedBookingsError(error: e.toString()));
    }
  }
}
