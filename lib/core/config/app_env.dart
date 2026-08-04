import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Valores leídos de `.env` tras `dotenv.load()`.
abstract final class AppEnv {
  static late final String apiBaseUrl;
  static late final int apiTimeoutMs;
  static late final String uploadFilesUrl;
  static late final double taxRate;

  static void init() {
    apiBaseUrl = dotenv.get(
      'API_BASE_URL',
      fallback: 'http://192.168.1.5:8080/api',
    );
    apiTimeoutMs =
        int.tryParse(dotenv.env['API_TIMEOUT'] ?? '') ?? 10000;
    uploadFilesUrl = dotenv.get(
      'UPLOAD_FILES_URL',
      fallback: 'http://192.168.1.5:8080',
    );
    taxRate = double.tryParse(dotenv.env['TAX_RATE'] ?? '') ?? 0.16;
  }
}
