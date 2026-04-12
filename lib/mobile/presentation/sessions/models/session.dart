class SessionModel {
  final String sessionId;
  final String userId;
  final String userImage;
  final String userName;
  final String userRole;
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
      required this.userId,
      required this.userImage,
      required this.userName,
      required this.userRole,
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
        userId: userId,
        userName: userName,
        userRole: userRole,
        userImage: userImage,
        dateTime: dateTime,
        price: price,
        status: status ?? this.status,
        rawStatus: rawStatus ?? this.rawStatus,
        timeAgo: timeAgo,
        isStudent: isStudent,
        duration: duration);
  }
}
