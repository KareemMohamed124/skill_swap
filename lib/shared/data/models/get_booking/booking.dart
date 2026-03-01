import 'package:skill_swap/shared/data/models/get_booking/user_id.dart';

import '../../../core/utils/id_normalizer.dart';

class GetBookingModel {
  final String id;
  final UserBooking studentId;
  final UserBooking instructorId;

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
      required this.studentId,
      required this.instructorId,
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
        id: IdNormalizer.normalize(json['_id']),
        studentId: UserBooking.fromJson(json['studentId']),
        instructorId: UserBooking.fromJson(json['instructorId']),
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
