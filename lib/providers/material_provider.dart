
import 'package:consorcio_app/models/material.dart';
import 'package:consorcio_app/services/material_service.dart';
import 'package:flutter/material.dart';

class MaterialProvider extends ChangeNotifier {
  final MaterialService _service;
  
  MaterialProvider(this._service);

  List<MaterialAlmacen> _materiales = [];
  List<MaterialAlmacen> get materiales => _materiales;

  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getMateriales() async {
    _isLoading = true;
    notifyListeners();

    try {
      _materiales = await _service.getMateriales();
    } catch (e) {
      _materiales = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMaterial(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevoMaterial = await _service.createMaterial(data);
      _materiales.add(nuevoMaterial);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMaterial(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedMaterial = await _service.updateMaterial(id, data);
      final index = _materiales.indexWhere((m) => m.id == id);
      if (index != -1) {
        _materiales[index] = updatedMaterial;
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