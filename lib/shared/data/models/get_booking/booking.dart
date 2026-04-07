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

  // ✅ New fields
  final String paymentStatus;
  final String? stripeSessionId;
  final String review;
  final bool isRated;
  final bool studentJoined;
  final bool instructorJoined;
  final bool reminderSent;
  final bool ratingRequestSent;

  GetBookingModel({
    required this.id,
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
    required this.v,
    required this.paymentStatus,
    required this.stripeSessionId,
    required this.review,
    required this.isRated,
    required this.studentJoined,
    required this.instructorJoined,
    required this.reminderSent,
    required this.ratingRequestSent,
  });

  factory GetBookingModel.fromJson(Map<String, dynamic> json) {
    return GetBookingModel(
      id: IdNormalizer.normalize(json['_id']),
      studentId: UserBooking.fromJson(json['studentId']),
      instructorId: UserBooking.fromJson(json['instructorId']),
      date: DateTime.parse(json['date']),
      time: json['time'] ?? '',
      durationMins: json['duration_mins'] ?? 0,
      price: json['price'] ?? 0,
      bookingCode: json['bookingCode'] ?? '',
      status: json['status'] ?? '',
      rate: json['rate'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,

      // ✅ New mappings
      paymentStatus: json['paymentStatus'] ?? '',
      stripeSessionId: json['stripeSessionId'],
      review: json['review'] ?? '',
      isRated: json['isRated'] ?? false,
      studentJoined: json['studentJoined'] ?? false,
      instructorJoined: json['instructorJoined'] ?? false,
      reminderSent: json['reminderSent'] ?? false,
      ratingRequestSent: json['ratingRequestSent'] ?? false,
    );
  }
}
