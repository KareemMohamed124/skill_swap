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
      id: json['_id']?.toString() ?? '',
      userId: json['userId'] != null && json['userId'] is Map<String, dynamic>
          ? UserBooking.fromJson(json['userId'])
          : UserBooking(id: '', name: '', email: ''),
      requestedUser: json['requestedUser'] != null &&
              json['requestedUser'] is Map<String, dynamic>
          ? UserBooking.fromJson(json['requestedUser'])
          : UserBooking(id: '', name: '', email: ''),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: json['time']?.toString() ?? '',
      durationMins: json['duration_mins'] is int
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
}
