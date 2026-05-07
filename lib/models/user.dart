class User {
  final int id;
  final String usuario;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.usuario,
    required this.email,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      usuario: json['usuario'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
    );
  }
}