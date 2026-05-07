
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/material.dart';

class MaterialService {
  final ApiClient api;
  MaterialService(this.api);

  Future<List<MaterialAlmacen>> getMateriales() async {
    final response = await api.get(
      ApiEndpoints.materiales,
    );
        
    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return (data['items'] as List).map((e) => MaterialAlmacen.fromJson(e)).toList();
  }

  Future<MaterialAlmacen> createMaterial(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.materiales,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return MaterialAlmacen.fromJson(response.data);
  }

  Future<MaterialAlmacen> updateMaterial(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.materiales}/$id",
      data: data,
    );

    return MaterialAlmacen.fromJson(response.data);
  }
}