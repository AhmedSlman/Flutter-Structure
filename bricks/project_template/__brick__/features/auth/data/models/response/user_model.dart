class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    avatar: json['avatar'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'avatar': avatar,
  };
}
