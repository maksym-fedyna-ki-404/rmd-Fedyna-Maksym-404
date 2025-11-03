class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
