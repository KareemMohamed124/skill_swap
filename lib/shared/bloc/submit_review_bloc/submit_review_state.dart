part of 'submit_review_bloc.dart';

@immutable
<<<<<<< HEAD
abstract class SubmitReviewState {}

class SubmitReviewInitial extends SubmitReviewState {}
=======
sealed class SubmitReviewState {}

final class SubmitReviewInitial extends SubmitReviewState {}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class SubmitReviewLoading extends SubmitReviewState {}

class SubmitReviewSuccessState extends SubmitReviewState {
<<<<<<< HEAD
  final String message;

  SubmitReviewSuccessState(this.message);
=======
  final SubmitReviewSuccessResponse success;

  SubmitReviewSuccessState(this.success);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}

class SubmitReviewFailureState extends SubmitReviewState {
  final SubmitReviewErrorResponse error;

  SubmitReviewFailureState(this.error);
}
