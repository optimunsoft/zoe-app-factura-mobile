import 'package:dio/dio.dart';

/// Valida el envelope común de la API: `{ status, message }`.
///
/// Si `status` no es `true`, lanza [Exception] con el `message` del backend.
void checkApiStatus(
  Map<String, dynamic> data, {
  String fallback = 'Error en la petición',
}) {
  if (data['status'] == true) return;

  final message = data['message']?.toString().trim();
  throw Exception(
    (message != null && message.isNotEmpty) ? message : fallback,
  );
}

/// Extrae el mensaje de un [DioException] (o un fallback de red).
Never throwFromDio(DioException e, {String fallback = 'Error de red'}) {
  final body = e.response?.data;
  if (body is Map && body['message'] != null) {
    final message = body['message'].toString().trim();
    if (message.isNotEmpty) throw Exception(message);
  }
  throw Exception(e.message ?? fallback);
}
