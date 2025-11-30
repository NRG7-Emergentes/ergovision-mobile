class UpdateUserRequest {
  final String email;
  final String imageUrl;
  final int age;
  final int height;
  final double weight;

  UpdateUserRequest({
    required this.email,
    required this.imageUrl,
    required this.age,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'imageUrl': imageUrl,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }
}

