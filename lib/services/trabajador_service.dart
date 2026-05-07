import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/trabajador.dart';

class TrabajadorService {
  final ApiClient api;

  TrabajadorService(this.api);

  Future<List<Trabajador>> getTrabajadores() async {
    final response = await api.get(
      ApiEndpoints.trabajadores,
    );
        
    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return (data['items'] as List).map((e) => Trabajador.fromJson(e)).toList();
  }

  Future<Trabajador> createTrabajador(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.trabajadores,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return Trabajador.fromJson(response.data);
  }

  Future<Trabajador> updateTrabajador(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.trabajadores}/$id",
      data: data,
    );

    return Trabajador.fromJson(response.data);
  }
}