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
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      requestedUser: json['requestedUser']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: json['time']?.toString() ?? '',
      duration_mins: json['duration_mins'] is int
          ? json['duration_mins']
          : int.tryParse(json['duration_mins']?.toString() ?? '') ?? 0,
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '') ?? 0,
      bookingCode: json['bookingCode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      rate: json['rate'] is int
          ? json['rate']
          : int.tryParse(json['rate']?.toString() ?? '') ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      v: json['__v'] is int
          ? json['__v']
          : int.tryParse(json['__v']?.toString() ?? '') ?? 0,
    );
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
