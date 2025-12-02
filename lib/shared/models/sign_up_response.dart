class SignUpResponse {
  final int id;
  final String username;
  final String email;
  final String imageUrl;
  final int age;
  final int height;
  final double weight;
  final List<String> roles;

  SignUpResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.age,
    required this.height,
    required this.weight,
    this.roles = const ["ROLE_USER"],
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'].toDouble(),
      roles: List<String>.from(json['roles']),
    );
  }
}