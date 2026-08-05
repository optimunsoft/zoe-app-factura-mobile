import 'package:dio/dio.dart';

import '../api_helpers.dart';
import 'api_client.dart';
import 'auth_models.dart';

/// Endpoints de autenticación.
/// Agregar más métodos en este mismo archivo.
class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// POST /auth/login-app
  Future<LoginResult> login({
    required String correo,
    required String clave,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login-app',
        data: {
          'correo': correo,
          'clave': clave,
        },
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data, showToast: false);

      final user = data['user'];
      final manejaInventario =
          user is Map && user['maneja_inventario'] == true;

      if (!manejaInventario) {
        throw Exception(
          'No tienes autorización para ingresar. La empresa no maneja inventario.',
        );
      }

      return LoginResult.fromJson(data);
    } on DioException catch (e) {
      throwFromDio(e, showToast: false);
    }
  }

  /// POST /auth/logout
  Future<void> logout() async {
    try {
      final response = await _dio.post('/auth/logout');
      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }
}
