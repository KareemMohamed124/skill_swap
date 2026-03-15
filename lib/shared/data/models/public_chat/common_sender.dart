class Sender {
  final String id;
  final String? name;
  final UserImage userImage;

  Sender({required this.id, this.name, required this.userImage});

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json['_id'],
        name: json['name'],
        userImage: UserImage.fromJson(json['userImage']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        if (name != null) 'name': name,
        'userImage': userImage.toJson(),
      };
}

class UserImage {
  final String secureUrl;
  final String publicId;

  UserImage({required this.secureUrl, required this.publicId});

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        secureUrl: json['secure_url'],
        publicId: json['public_id'],
      );

  Map<String, dynamic> toJson() => {
        'secure_url': secureUrl,
        'public_id': publicId,
      };
}
