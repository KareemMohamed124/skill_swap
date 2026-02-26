class SessionModel {
  final String sessionId;
  final String userId;
  final String image;
  final String name;
  final String role;
  final DateTime dateTime;
  final String price;
  final String status;
  final String rawStatus;
  final String timeAgo;

  SessionModel(
      {required this.sessionId,
      required this.userId,
      required this.image,
      required this.name,
      required this.role,
      required this.dateTime,
      required this.price,
      required this.status,
      required this.rawStatus,
      required this.timeAgo});
}
