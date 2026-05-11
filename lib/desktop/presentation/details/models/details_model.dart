class SessionModel {
  final String mentorId;
  final String mentorName;
  final String mentorTrack;
  final String mentorImage;
  final String status;
  final DateTime date;
  final String time;
  final String duration;
  final String notes;
<<<<<<< HEAD
  final double rating;
=======
  final int rating;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final String review;

  SessionModel({
    required this.mentorId,
    required this.mentorName,
    required this.mentorTrack,
    required this.mentorImage,
    required this.status,
    required this.date,
    required this.time,
    required this.duration,
    required this.notes,
    required this.rating,
    required this.review,
  });
}
