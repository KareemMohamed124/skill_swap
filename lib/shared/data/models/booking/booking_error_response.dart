import 'booking_validation_error.dart';

class BookingErrorResponse {
  final String message;
  final List<BookingValidationError>? validationErrors;

  BookingErrorResponse({required this.message, this.validationErrors});

  factory BookingErrorResponse.fromJson(Map<String, dynamic> json) {
    // Backend may send 'validationErrors' or 'errors'
    final rawErrors = json['validationErrors'] ?? json['errors'];
    List<BookingValidationError>? parsedErrors;

    if (rawErrors != null && rawErrors is List) {
      parsedErrors = rawErrors
          .whereType<Map<String, dynamic>>()
          .map((e) => BookingValidationError.fromJson(e))
          .toList();
    }

    return BookingErrorResponse(
      message: json['message']?.toString() ?? 'Unknown error',
      validationErrors: parsedErrors,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'validationErrors': validationErrors?.map((e) => e.toJson()).toList(),
      };
}
