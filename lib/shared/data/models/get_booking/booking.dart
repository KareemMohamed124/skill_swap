import 'package:skill_swap/shared/data/models/get_booking/user_id.dart';

class GetBookingModel {
  final String id;
  final UserBooking userId;
  final UserBooking requestedUser;

  final DateTime date;
  final String time;
  final int durationMins;
  final int price;
  final String bookingCode;
  final String status;
  final int rate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  GetBookingModel(
      {required this.id,
      required this.userId,
      required this.requestedUser,
      required this.date,
      required this.time,
      required this.durationMins,
      required this.price,
      required this.bookingCode,
      required this.status,
      required this.rate,
      required this.createdAt,
      required this.updatedAt,
      required this.v});

  factory GetBookingModel.fromJson(Map<String, dynamic> json) {
    return GetBookingModel(
        id: json['_id'],
        userId: UserBooking.fromJson(json['userId']),
        requestedUser: UserBooking.fromJson(json['requestedUser']),
        date: DateTime.parse(json['date']),
        time: json['time'],
        durationMins: json['duration_mins'],
        price: json['price'],
        bookingCode: json['bookingCode'],
        status: json['status'],
        rate: json['rate'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v']);
  }
}
