import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/core/utils/api_utils.dart';
import 'package:consorcio_app/models/auth_session.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient api;
  String? _token;

  String? get token => _token;

  AuthService(this.api);

  Future<AuthSession> login(String email, String password) async {
    try {
      print('Enviando datos al backend: email=$email, password=$password');
      final response = await api.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Respuesta del backend: ${response.data}');

      final Map<String, dynamic> body = response.data is String
        ? jsonDecode(response.data)
        : response.data;

      if (body['token'] == null || body['user'] == null) {
        throw "Respuesta inválida del servidor";
      }

      final session = AuthSession.fromJson(body);

      _token = session.token;

      return session;

    } on DioException catch (e) {
      throw extractErrorMessage(e.response?.data);
    } catch (e) {
      throw "Error inesperado";
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await api.post(
        ApiEndpoints.forgotPassword,
        data: {'Email': email},
      );
    } on DioException catch (e) {
      throw extractErrorMessage(e.response?.data);
    } catch (_) {
      throw "Error inesperado";
    }
  }

  Future<void> verifyCode(String email, String code) async {
    try {
      await api.post(
        ApiEndpoints.verifyCode,
        data: {
          'email': email,
          'code': code,
        },
      );
    } on DioException catch (e) {
      throw extractErrorMessage(e.response?.data);
    } catch (_) {
      throw "Error inesperado";
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    print('Enviando datos al backend para resetear contraseña: email=$email, newPassword=$newPassword');
    try {
      await api.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'newPassword': newPassword
        },
      );
    } on DioException catch (e) {
      final message = e.response?.data?["message"]["message"] ?? "Error de conexión";
      throw Exception(message);
    } catch (e) {
      throw Exception("Error inesperado");
    }
  }
}
