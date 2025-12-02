class SignUpRequest {
  final String username;
  final String email;
  final String imageUrl;
  final int age;
  final int height;
  final double weight;
  final String password;
  final List<String> roles;

  SignUpRequest({
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.age,
    required this.height,
    required this.weight,
    required this.password,
    this.roles = const ["ROLE_USER"],
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'imageUrl': imageUrl,
    'age': age,
    'height': height,
    'weight': weight,
    'password': password,
    'roles': roles,
  };
}