
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/tipoSueldo.dart';

class TipoSueldoService {
  final ApiClient api;
  
  TipoSueldoService(this.api);

  Future<List<TipoSueldo>> getTiposSueldo() async {
    final response = await api.get(
      ApiEndpoints.tiposSueldo,
    );
    
    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return (data['items'] as List).map((e) => TipoSueldo.fromJson(e)).toList();
  }

  Future<TipoSueldo> createTipoSueldo(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.tiposSueldo,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return TipoSueldo.fromJson(response.data);
  }

  Future<TipoSueldo> updateTipoSueldo(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.tiposSueldo}/$id",
      data: data,
    );

    return TipoSueldo.fromJson(response.data);
  }
}