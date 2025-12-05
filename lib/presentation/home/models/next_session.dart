class NextSession {
  final String image;
  final String name;
  final String time;
  final String duration;

  NextSession({
    required this.image,
    required this.name,
    required this.time,
    required this.duration,
  });

  factory NextSession.fromJson(Map<String, dynamic> json) {
    return NextSession(
      image: json['image'],
      name: json['name'],
      time: json['time'],
      duration: json['duration'],
    );
  }
}