class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  String get uid => id;

  factory UserModel.fromDoc(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
