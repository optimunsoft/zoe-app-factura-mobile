import 'package:dio/dio.dart';

import '../config/app_env.dart';

/// Cliente HTTP único de la app.
abstract final class ApiClient {
  static final Dio dio = _create();

  /// Token de sesión. Lo setea [AuthController] al hacer login/logout.
  static String? accessToken;
  static String tokenType = 'Bearer';

  static Dio _create() {
    final client = Dio(
      BaseOptions(
        baseUrl: AppEnv.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppEnv.apiTimeoutMs),
        receiveTimeout: Duration(milliseconds: AppEnv.apiTimeoutMs),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Adjunta Authorization en todas las peticiones (excepto login).
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final isLogin = options.path.contains('/auth/login-app');
          final token = accessToken;

          if (!isLogin && token != null && token.isNotEmpty) {
            options.headers['Authorization'] = '$tokenType $token';
          }

          handler.next(options);
        },
      ),
    );

    client.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print(object),
      ),
    );

    return client;
  }
}
