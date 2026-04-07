import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/cancel_booking/cancel_booking_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'cancel_book_event.dart';

part 'cancel_book_state.dart';

class CancelBookBloc extends Bloc<CancelBookEvent, CancelBookState> {
  final BookingRepository repo;

  CancelBookBloc(this.repo) : super(CancelBookInitial()) {
    on<CancelBookSession>((event, emit) async {
      emit(CancelBookLoading());

      final response = await repo.cancelBookSession(event.id);

      switch (response) {
        case CancelBookingSuccess s:
          emit(CancelBookSuccess(success: s));
          break;
        case CancelBookingFailure f:
          emit(CancelBookFailure(error: f));
          break;
      }
    });
  }
}
