import 'package:consorcio_app/models/tipoSueldo.dart';
import 'package:consorcio_app/services/tipoSueldo_service.dart';
import 'package:flutter/foundation.dart';

class TipoSueldoProvider extends ChangeNotifier {
  final TipoSueldoService _service;

  TipoSueldoProvider(this._service);

  List<TipoSueldo> _tiposSueldo = [];
  List<TipoSueldo> get tiposSueldo => _tiposSueldo;

  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getTiposSueldo() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tiposSueldo = await _service.getTiposSueldo();
    } catch (e) {
      _tiposSueldo = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTipoSueldo(Map<String, dynamic> data) async {
    _isLoading = true;

    try {
      final nuevoTipoSueldo = await _service.createTipoSueldo(data);
      _tiposSueldo.add(nuevoTipoSueldo);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> updateTipoSueldo(int id, Map<String, dynamic> data) async {
    _isLoading = true;

    try {
      final updatedTipoSueldo = await _service.updateTipoSueldo(id, data);
      final index = _tiposSueldo.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tiposSueldo[index] = updatedTipoSueldo;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}