
import 'package:consorcio_app/models/area.dart';
import 'package:consorcio_app/services/area_service.dart';
import 'package:flutter/foundation.dart';

class AreaProvider extends ChangeNotifier {
  final AreaService _service;

  AreaProvider(this._service);

  List<Area> _areas = [];
  List<Area> get areas => _areas;

  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getAreas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _areas = await _service.getAreas();
    } catch (e) {
      _areas = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createArea(Map<String, dynamic> data) async {
    _isLoading = true;

    try {
      final nuevaArea = await _service.createArea(data);
      _areas.add(nuevaArea);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> updateArea(int id, Map<String, dynamic> data) async {
    _isLoading = true;

    try {
      final updatedArea = await _service.updateArea(id, data);
      final index = _areas.indexWhere((a) => a.id == id);
      if (index != -1) {
        _areas[index] = updatedArea;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}