class SessionModel {
  final String sessionId;
  final String instructorId;
  final String image;
  final String name;
  final String role;
  final DateTime dateTime;
  final int price;
  final String status;
  final String rawStatus;
  final DateTime timeAgo;

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
      required this.timeAgo});
}
