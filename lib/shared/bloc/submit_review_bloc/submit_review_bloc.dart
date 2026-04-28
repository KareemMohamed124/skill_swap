import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/submit_review/submit_review_error_response.dart';
import '../../data/models/submit_review/submit_review_request.dart';
import '../../data/models/submit_review/submit_review_response.dart';
import '../../data/models/submit_review/submit_review_success_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'submit_review_event.dart';

part 'submit_review_state.dart';

class SubmitReviewBloc extends Bloc<SubmitReviewEvent, SubmitReviewState> {
  final BookingRepository repository;

  SubmitReviewBloc(this.repository) : super(SubmitReviewInitial()) {
    on<ConfirmSubmit>((event, emit) async {
      emit(SubmitReviewLoading());

      final result = await repository.submitReview(event.id, event.request);

      switch (result) {
        case SubmitReviewSuccess s:
          emit(SubmitReviewSuccessState(s.success));
          emit(SubmitReviewInitial());
          break;
        case SubmitReviewFailure f:
          emit(SubmitReviewFailureState(f.error));
      }
    });
  }
}
