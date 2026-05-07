import 'package:consorcio_app/models/user.dart';
import 'package:consorcio_app/services/usuario_service.dart';
import 'package:flutter/material.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service;

  UsuarioProvider(this._service);

  User? _usuario;
  User? get usuario => _usuario;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getUsuarioById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _service.getUsuarioById(id);
    } catch (e) {
      _usuario = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}