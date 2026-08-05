import 'package:flutter/foundation.dart';

import '../api_helpers.dart';
import 'api_client.dart';
import 'auth_models.dart';
import 'auth_service.dart';

/// Estado simple de sesión (lo actualiza el login tras el POST).
class AuthController extends ChangeNotifier {
  AuthController({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  LoginResult? loginResult;
  String? error;
  bool isLoggingOut = false;

  bool get isLoggedIn => loginResult != null;
  String? get accessToken => loginResult?.accessToken;
  AuthUser? get user => loginResult?.user;

  void setSession(LoginResult result) {
    loginResult = result;
    error = null;
    ApiClient.accessToken = result.accessToken;
    ApiClient.tokenType = result.tokenType;
    notifyListeners();
  }

  void setError(String message) {
    loginResult = null;
    error = message;
    ApiClient.accessToken = null;
    notifyListeners();
  }

  /// POST /auth/logout y limpia la sesión local.
  /// Aunque falle la API, cierra la sesión en el dispositivo.
  Future<void> logout() async {
    if (isLoggingOut) return;

    isLoggingOut = true;
    error = null;
    notifyListeners();

    try {
      await _authService.logout();
    } catch (e) {
      error = cleanErrorMessage(e);
      // Se limpia igual: el usuario pidió salir.
    }

    loginResult = null;
    ApiClient.accessToken = null;
    ApiClient.tokenType = 'Bearer';
    isLoggingOut = false;
    notifyListeners();
  }
}
