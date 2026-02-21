class UserImage {
  final String secureUrl;
  final String? publicId;

  UserImage({
    required this.secureUrl,
    this.publicId,
  });

  factory UserImage.fromJson(Map<String, dynamic>? json) {
    return UserImage(
      secureUrl: json?['secure_url'] ?? '',
      publicId: json?['public_id'],
    );
  }

  factory UserImage.empty() {
    return UserImage(secureUrl: "", publicId: "");
  }
}
