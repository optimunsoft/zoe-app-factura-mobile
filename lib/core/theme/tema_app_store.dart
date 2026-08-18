import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';

/// Preferencia de tema claro/oscuro. Sin lógica de negocio.
class TemaAppStore extends ChangeNotifier {
  static const _clave = 'tema_oscuro';

  bool _oscuro = false;

  bool get oscuro => _oscuro;

  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    _oscuro = prefs.getBool(_clave) ?? false;
    AppColors.aplicarOscuro(_oscuro);
    notifyListeners();
  }

  void setOscuro(bool value) {
    if (_oscuro == value) return;
    _oscuro = value;
    AppColors.aplicarOscuro(value);
    notifyListeners();
    unawaited(_persistir(value));
  }

  Future<void> _persistir(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clave, value);
  }
}
