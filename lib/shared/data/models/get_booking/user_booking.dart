class UserBooking {
  final String id;
  final String name;
  final String email;

  UserBooking({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserBooking.fromJson(Map<String, dynamic> json) {
    return UserBooking(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
