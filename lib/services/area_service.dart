
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/area.dart';

class AreaService {
  final ApiClient api;
  
  AreaService(this.api);

  Future<List<Area>> getAreas() async {
    final response = await api.get(
      ApiEndpoints.areas,
    );
    
    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return (data['items'] as List).map((e) => Area.fromJson(e)).toList();
  }

  Future<Area> createArea(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.areas,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return Area.fromJson(response.data);
  }

  Future<Area> updateArea(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.areas}/$id",
      data: data,
    );

    return Area.fromJson(response.data);
  }
}