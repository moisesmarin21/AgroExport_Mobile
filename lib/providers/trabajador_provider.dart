import 'package:consorcio_app/models/trabajador.dart';
import 'package:consorcio_app/services/trabajador_service.dart';
import 'package:flutter/material.dart';

class TrabajadorProvider extends ChangeNotifier {
  final TrabajadorService _service;

  TrabajadorProvider(this._service);
  
  List<Trabajador> _trabajadores = [];
  List<Trabajador> get trabajadores => _trabajadores;

  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getTrabajadores() async {
    _isLoading = true;
    notifyListeners();

    try {
      _trabajadores = await _service.getTrabajadores();
    } catch (e) {
      _trabajadores = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTrabajador(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevoTrabajador = await _service.createTrabajador(data);
      _trabajadores.add(nuevoTrabajador);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTrabajador(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedTrabajador = await _service.updateTrabajador(id, data);
      final index = _trabajadores.indexWhere((t) => t.id == id);
      if (index != -1) {
        _trabajadores[index] = updatedTrabajador;
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