
import 'package:consorcio_app/models/tareo.dart';
import 'package:consorcio_app/services/tareo_service.dart';
import 'package:flutter/material.dart';

class TareoProvider extends ChangeNotifier {
  TareoService tareoService;
  
  TareoProvider(this.tareoService);

  List<Tareo> _tareos = [];
  List<Tareo> get tareos => _tareos;
  
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  int _pageNumber = 1;
  int _pageSize = 10;
  int _totalPages = 1;

  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _pageNumber < _totalPages;

  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now();

  DateTime get fechaInicio => _fechaInicio;
  DateTime get fechaFin => _fechaFin;

  Future<void> aplicarFiltros({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    _fechaInicio = fechaInicio;
    _fechaFin = fechaFin;

    await getTareos();
  }

  Future<void> getTareos() async {
    _isLoading = true;
    _pageNumber = 1;
    notifyListeners();

    try {
      final result = await tareoService.getTareos(
        pageNumber: _pageNumber,
        pageSize: _pageSize,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
      );

      _tareos = result.items;
      _totalPages = result.totalPages;

    } catch (e) {
      _tareos = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isFetchingMore || !hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _pageNumber++;

      final result = await tareoService.getTareos(
        pageNumber: _pageNumber,
        pageSize: _pageSize,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
      );

      _tareos.addAll(result.items);

    } catch (e) {
      _error = e.toString();
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> createTareo(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevoTareo = await tareoService.createTareo(data);
      _tareos.add(nuevoTareo);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTareo(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedTareo = await tareoService.updateTareo(id, data);
      final index = _tareos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tareos[index] = updatedTareo;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}