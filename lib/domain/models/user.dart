class User {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String? profileImage;
  final String? about;
  final int religionId;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    this.profileImage,
    this.about,
    required this.religionId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      about: json['about'],
      religionId: json['religion_id'] ?? 0,
    );
  }

  // Método útil para obtener el nombre completo
  String get fullName => '$name $lastname';
}