class HistoryModel {
  final String name;
  final String role;
  final String date;
  final String time;
  final String duration;
  final String status;        // Finished / Rejected / Cancelled
  final double rating;        // 0 → 5
  final String? errorMessage; // لو فيه سبب زي Schedule conflict
  final String imageUrl;

  HistoryModel({
    required this.name,
    required this.role,
    required this.date,
    required this.time,
    required this.duration,
    required this.status,
    required this.rating,
    required this.imageUrl,
    this.errorMessage,
  });
}