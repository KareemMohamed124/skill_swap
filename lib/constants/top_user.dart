class TopUser {
  final String image;
  final String name;
  final String track;
  final String hours;

  TopUser({
    required this.image,
    required this.name,
    required this.track,
    required this.hours,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      image: json['image'],
      name: json['name'],
      track: json['track'],
      hours: json['hours'],
    );
  }
}