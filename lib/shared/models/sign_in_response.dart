class SignInResponse {
  final int id;
  final String username;
  final String imageUrl;
  final String token;

  SignInResponse({
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.token,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      id: json['id'],
      username: json['username'],
      imageUrl: json['imageUrl'],
      token: json['token'],
    );
  }
}