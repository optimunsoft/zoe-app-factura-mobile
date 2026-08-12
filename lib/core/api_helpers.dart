import 'dart:convert';

import 'package:dio/dio.dart';

import 'app_toast.dart';

/// Extrae el texto de error del envelope de la API.
///
/// La API puede enviar `error` o `message` (p. ej. `{"status":false,"error":"..."}`).
String? apiMessageFrom(dynamic data) {
  if (data is String) {
    final trimmed = data.trim();
    if (trimmed.isEmpty) return null;
    try {
      return apiMessageFrom(jsonDecode(trimmed));
    } catch (_) {
      return null;
    }
  }

  if (data is Map) {
    for (final key in ['error', 'message', 'msg', 'detalle']) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    // Algunas respuestas anidan el texto en `response` como String.
    final response = data['response'];
    if (response is String && response.trim().isNotEmpty) {
      return response.trim();
    }
  }
  return null;
}

/// Valida el envelope común de la API: `{ status, error|message }`.
///
/// Si `status` no es `true`, lanza [Exception] con el texto del backend.
/// Por defecto también muestra toast ([showToast]).
void checkApiStatus(
  Map<String, dynamic> data, {
  bool showToast = true,
}) {
  if (data['status'] == true) return;

  final message = apiMessageFrom(data) ?? '';
  if (showToast && message.isNotEmpty) {
    AppToast.error(message);
  }
  throw Exception(message);
}

/// Maneja un [DioException] (p. ej. HTTP 400).
///
/// Lee `error`/`message` del body. Nunca propaga el texto técnico de Dio.
Never throwFromDio(
  DioException e, {
  bool showToast = true,
}) {
  final message = apiMessageFrom(e.response?.data) ?? '';

  if (message.isNotEmpty) {
    if (showToast) {
      AppToast.error(message);
    }
    throw Exception(message);
  }

  throw Exception('');
}

/// Mensaje limpio para UI a partir de cualquier error capturado.
String cleanErrorMessage(Object error) {
  if (error is DioException) {
    return apiMessageFrom(error.response?.data) ?? '';
  }

  var text = error.toString().trim();
  if (text.startsWith('Exception: ')) {
    text = text.substring('Exception: '.length).trim();
  }

  if (text.startsWith('DioException')) return '';

  return text;
}

/// Parseo seguro de enteros (acepta `num` o `String`).
int? asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed) ?? double.tryParse(trimmed)?.toInt();
  }
  return null;
}

/// Parseo seguro de doubles (acepta `num` o `String`).
double? asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim().replaceAll(',', '');
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
  return null;
}
