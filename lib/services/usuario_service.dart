
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/user.dart';

class UsuarioService {
  final ApiClient api;

  UsuarioService(this.api);

  Future<User> getUsuarioById(int id) async {
    final response = await api.get(
      '${ApiEndpoints.usuarios}/$id',
    );

    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data;

    return User.fromJson(data); // 👈 objeto único
  }
}