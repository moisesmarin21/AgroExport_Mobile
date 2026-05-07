import 'package:consorcio_app/models/user.dart';

class AuthSession {
  final String token;
  final User user;

  AuthSession({
    required this.token,
    required this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}