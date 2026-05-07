
import 'dart:convert';

import 'package:consorcio_app/core/api/api_client.dart';
import 'package:consorcio_app/core/api/api_endpoints.dart';
import 'package:consorcio_app/models/proveedor.dart';

class ProveedorService {
  final ApiClient api;

  ProveedorService(this.api);

  Future<List<Proveedor>> getProveedores() async {
    final response = await api.get(
      ApiEndpoints.proveedores,
    );
        
    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return (data['items'] as List).map((e) => Proveedor.fromJson(e)).toList();
  }

  Future<Proveedor> createProveedor(Map<String, dynamic> data) async {
    print('Enviando datos al backend: $data');
    final response = await api.post(
      ApiEndpoints.proveedores,
      data: data,
    );

    print('Respuesta del backend: ${response.data}');

    return Proveedor.fromJson(response.data);
  }

  Future<Proveedor> updateProveedor(int id, Map<String, dynamic> data) async {
    final response = await api.put(
      "${ApiEndpoints.proveedores}/$id",
      data: data,
    );

    return Proveedor.fromJson(response.data);
  }
}