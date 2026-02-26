class Booking {
  final String userId;
  final String requestedUser;

  final DateTime date;
  final String time;
  final int duration_mins;
  final int price;
  final String bookingCode;
  final String status;
  final int rate;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Booking(
      {required this.id,
      required this.userId,
      required this.requestedUser,
      required this.date,
      required this.time,
      required this.duration_mins,
      required this.price,
      required this.bookingCode,
      required this.status,
      required this.rate,
      required this.createdAt,
      required this.updatedAt,
      required this.v});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
        id: json['_id'],
        userId: json['userId'],
        requestedUser: json['requestedUser'],
        date: DateTime.parse(json['date']),
        time: json['time'],
        duration_mins: json['duration_mins'],
        price: json['price'],
        bookingCode: json['bookingCode'],
        status: json['status'],
        rate: json['rate'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'requestedUser': requestedUser,
      'date': date.toIso8601String(),
      'time': time,
      'duration_mins': duration_mins,
      'price': price,
      'bookingCode': bookingCode,
      'status': status,
      'rate': rate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v
    };
  }
}
