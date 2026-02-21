import 'package:skill_swap/shared/data/models/get_booking/user_booking.dart';

class Booking {
  final String id;
  final UserBooking user;
  final DateTime date;
  final String time;
  final int durationMins;
  final int price;
  final String bookingCode;
  final String status;
  final int rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.user,
    required this.date,
    required this.time,
    required this.durationMins,
    required this.price,
    required this.bookingCode,
    required this.status,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      user: UserBooking.fromJson(json['userId']),
      date: DateTime.parse(json['date']),
      time: json['time'],
      durationMins: json['duration_mins'],
      price: json['price'],
      bookingCode: json['bookingCode'],
      status: json['status'],
      rate: json['rate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
