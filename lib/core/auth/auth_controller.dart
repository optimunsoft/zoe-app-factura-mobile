import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'auth_models.dart';

/// Estado simple de sesión (lo actualiza el login tras el POST).
class AuthController extends ChangeNotifier {
  LoginResult? loginResult;
  String? error;

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

  void logout() {
    loginResult = null;
    error = null;
    ApiClient.accessToken = null;
    notifyListeners();
  }
}
