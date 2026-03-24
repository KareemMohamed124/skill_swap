part of 'submit_review_bloc.dart';

@immutable
sealed class SubmitReviewState {}

final class SubmitReviewInitial extends SubmitReviewState {}

class SubmitReviewLoading extends SubmitReviewState {}

class SubmitReviewSuccessState extends SubmitReviewState {
  final SubmitReviewSuccessResponse success;

  SubmitReviewSuccessState(this.success);
}

class SubmitReviewFailureState extends SubmitReviewState {
  final SubmitReviewErrorResponse error;

  SubmitReviewFailureState(this.error);
}
