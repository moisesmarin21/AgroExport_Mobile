
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/paginatedTareo.dart';
import 'package:consorcio_app/models/tareo.dart';

class TareoService{
  final ApiClient api;

  TareoService(this.api);

  Future<PaginatedTareo> getTareos({required int pageNumber, required int pageSize, required DateTime fechaInicio, required DateTime fechaFin,}) async {
    final fi = fechaInicio.toIso8601String().split('T').first;
    final ff = fechaFin.toIso8601String().split('T').first;
    print('Obteniendo tareos - Página: $pageNumber, Tamaño: $pageSize, Fecha Inicio: $fi, Fecha Fin: $ff');
    final response = await api.get(
      "${ApiEndpoints.tareos}?pageNumber=$pageNumber&pageSize=$pageSize&fechaInicio=$fi&fechaFin=$ff",
    );

    print('Respuesta del backend: ${response.data}');

    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    final items = (data['items'] as List)
        .map((e) => Tareo.fromJson(e))
        .toList();

    return PaginatedTareo(
      items: items,
      totalCount: data['totalCount'],
      pageNumber: data['pageNumber'],
      totalPages: data['totalPages'],
    );
  }

  Future<Tareo> createTareo(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.tareos,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return Tareo.fromJson(response.data);
  }

  Future<Tareo> updateTareo(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.tareos}/$id",
      data: data,
    );

    return Tareo.fromJson(response.data);
  }

}