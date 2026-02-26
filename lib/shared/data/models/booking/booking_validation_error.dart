class BookingValidationError {
  final String field;
  final String message;

  BookingValidationError({required this.field, required this.message});

  factory BookingValidationError.fromJson(Map<String, dynamic> json) {
    return BookingValidationError(
      field: json['field']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'field': field,
        'message': message,
      };
}
