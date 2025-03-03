class User {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.role,
    required this.createdAt,
  });

  set id(String id) {
    this.id = id;
  }

  set name(String name) {
    this.name = name;
  }

  set email(String email) {
    this.email = email;
  }

  set cpf(String cpf) {
    this.cpf = cpf;
  }

  set role(String role) {
    this.role = role;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cpf: json['cpf'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
