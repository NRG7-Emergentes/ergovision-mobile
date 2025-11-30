class User{
  final int id;
  final String username;
  final String email;
  final String imageUrl;
  final int age;
  final int height;
  final double weight;
  final List<String> roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.age,
    required this.height,
    required this.weight,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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