import 'package:consorcio_app/models/actividad.dart';
import 'package:consorcio_app/services/actividad_service.dart';
import 'package:flutter/material.dart';

class ActividadProvider extends ChangeNotifier {
  final ActividadService _service;

  ActividadProvider(this._service);

  List<Actividad> _actividades = [];

  bool _isLoading = false;
  String? _error;

  List<Actividad> get actividades => _actividades;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getActividades() async {
    _isLoading = true;
    notifyListeners();

    try {
      _actividades = await _service.getActividades();
    } catch (e) {
      _actividades = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createActividad(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevoActividad = await _service.createActividad(data);
      _actividades.add(nuevoActividad);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateActividad(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedActividad = await _service.updateActividad(id, data);
      final index = _actividades.indexWhere((a) => a.id == id);
      if (index != -1) {
        _actividades[index] = updatedActividad;
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