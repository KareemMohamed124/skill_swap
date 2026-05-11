class JoinResponse {
  String? message;

  JoinResponse({this.message});

  JoinResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
