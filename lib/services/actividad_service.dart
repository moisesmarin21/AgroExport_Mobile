
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/actividad.dart';

class ActividadService {
  final ApiClient api;

  ActividadService(this.api);

  Future<List<Actividad>> getActividades() async {
    final response = await api.get(
      ApiEndpoints.actividades,
    );
        
    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return (data['items'] as List).map((e) => Actividad.fromJson(e)).toList();
  }

  Future<Actividad> createActividad(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.actividades,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return Actividad.fromJson(response.data);
  }

  Future<Actividad> updateActividad(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.actividades}/$id",
      data: data,
    );

    return Actividad.fromJson(response.data);
  }
}