import 'package:consorcio_app/models/proveedor.dart';
import 'package:consorcio_app/services/proveedor_service.dart';
import 'package:flutter/material.dart';

class ProveedorProvider extends ChangeNotifier {
  final ProveedorService _service;

  ProveedorProvider(this._service);

  List<Proveedor> _proveedores = [];

  bool _isLoading = false;
  String? _error;

  List<Proveedor> get proveedores => _proveedores;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getProveedores() async {
    _isLoading = true;
    notifyListeners();

    try {
      _proveedores = await _service.getProveedores();
    } catch (e) {
      _proveedores = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProveedor(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevoProveedor = await _service.createProveedor(data);
      _proveedores.add(nuevoProveedor);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProveedor(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedProveedor = await _service.updateProveedor(id, data);
      final index = _proveedores.indexWhere((p) => p.id == id);
      if (index != -1) {
        _proveedores[index] = updatedProveedor;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}