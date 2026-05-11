<<<<<<< HEAD
import 'dart:ui';

class NextSession {
  final String name;
  final DateTime sessionTime;
  final String dateTime;
  final String duration;
  final bool isMentor;
  final VoidCallback? onTap;

  //final int remainingMinutes;

  NextSession(
      {required this.name,
      required this.dateTime,
      required this.duration,
      required this.sessionTime,
      this.isMentor = true,
      this.onTap});

  factory NextSession.fromJson(Map<String, dynamic> json) {
    return NextSession(
        name: json['name'],
        dateTime: json['date_time'],
        duration: json['duration'],
        sessionTime: json['session_time'],
        isMentor: json['is_mentor'] ?? true,
        onTap: null);
=======
class NextSession {
  final String image;
  final String name;
  final String dateTime;
  final String duration;
  final String startsIn;
  final bool isMentor;
  final int remainingMinutes;

  NextSession(
      {required this.image,
      required this.name,
      required this.dateTime,
      required this.duration,
      required this.startsIn,
      this.isMentor = true,
      required this.remainingMinutes});

  factory NextSession.fromJson(Map<String, dynamic> json) {
    return NextSession(
        image: json['image'] ?? '',
        name: json['name'],
        dateTime: json['date_time'],
        duration: json['duration'],
        startsIn: json['starts_in'],
        isMentor: json['is_mentor'] ?? true,
        remainingMinutes: json['remainingMinutes']);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }
}
