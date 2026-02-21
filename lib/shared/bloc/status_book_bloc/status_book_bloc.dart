import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/status_booking/status_booking_request.dart';
import '../../data/models/status_booking/status_booking_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'status_book_event.dart';

part 'status_book_state.dart';

class StatusBookBloc extends Bloc<StatusBookEvent, StatusBookState> {
  final BookingRepository repo;

  StatusBookBloc(this.repo) : super(StatusBookInitial()) {
    on<StatusBookSession>((event, emit) async {
      emit(StatusBookLoading());

      final response = await repo.statusBookSession(event.id, event.request);

      switch (response) {
        case StatusBookingSuccess s:
          emit(StatusBookSuccess(success: s));
          break;
        case StatusBookingFailure f:
          emit(StatusBookFailure(error: f));
          break;
      }
    });
  }
}
