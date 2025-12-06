class RecommendedMentor {
  final String image;
  final String name;
  final double stars;
  final String track;

  RecommendedMentor({
    required this.image,
    required this.name,
    required this.stars,
    required this.track,
  });

  factory RecommendedMentor.fromJson(Map<String, dynamic> json) {
    return RecommendedMentor(
      image: json['image'],
      name: json['name'],
      stars: json['stars'],
      track: json['track'],
    );
  }
}