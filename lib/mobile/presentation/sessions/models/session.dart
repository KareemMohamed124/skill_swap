class SessionModel {
  final String sessionId;
<<<<<<< HEAD
  final String userId;
  final String studentId;
  final String userImage;
  final String userName;
  final String userRole;
  final DateTime dateTime;
  final num duration;
  final num price;
=======
  final String instructorId;
  final String image;
  final String name;
  final String role;
  final DateTime dateTime;
  final int price;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final String status;
  final String rawStatus;
  final DateTime timeAgo;
  final String bookingCode;
  final bool isStudent;
<<<<<<< HEAD
  final String paymentStatus;
  final bool studentJoined;
  final bool instructorJoined;

  // final DateTime createAt;

  SessionModel(
      {required this.sessionId,
      required this.userId,
      required this.studentId,
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
      required this.duration,
      required this.instructorJoined,
      required this.studentJoined,
      required this.paymentStatus});

  SessionModel copyWith({
    String? status,
    String? rawStatus,
  }) {
    return SessionModel(
        sessionId: sessionId,
        bookingCode: bookingCode,
        userId: userId,
        instructorJoined: instructorJoined,
        studentJoined: studentJoined,
        studentId: studentId,
        userName: userName,
        userRole: userRole,
        userImage: userImage,
        dateTime: dateTime,
        price: price,
        status: status ?? this.status,
        rawStatus: rawStatus ?? this.rawStatus,
        timeAgo: timeAgo,
        isStudent: isStudent,
        duration: duration,
        paymentStatus: paymentStatus);
  }
=======

  // final DateTime createAt;

  SessionModel({required this.sessionId,
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
    required this.isStudent
  });
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
