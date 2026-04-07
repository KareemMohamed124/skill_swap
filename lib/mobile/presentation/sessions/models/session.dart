class SessionModel {
  final String sessionId;
  final String instructorId;
  final String image;
  final String name;
  final String role;
  final DateTime dateTime;
  final int duration;
  final int price;
  final String status;
  final String rawStatus;
  final DateTime timeAgo;
  final String bookingCode;
  final bool isStudent;

  // final DateTime createAt;

  SessionModel(
      {required this.sessionId,
      required this.instructorId,
      required this.image,
      required this.name,
      required this.role,
      required this.dateTime,
      required this.price,
      required this.status,
      required this.rawStatus,
      required this.timeAgo,
      required this.bookingCode,
      required this.isStudent,
      required this.duration});

  SessionModel copyWith({
    String? status,
    String? rawStatus,
  }) {
    return SessionModel(
        sessionId: sessionId,
        bookingCode: bookingCode,
        instructorId: instructorId,
        name: name,
        role: role,
        image: image,
        dateTime: dateTime,
        price: price,
        status: status ?? this.status,
        rawStatus: rawStatus ?? this.rawStatus,
        timeAgo: timeAgo,
        isStudent: isStudent,
        duration: duration);
  }
}
