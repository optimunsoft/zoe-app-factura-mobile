import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/list_sales.models.dart';
import '../domain/models/sales.models.dart';
import '../domain/models/ventas_resumen.models.dart';

/// Tipo de documento por defecto para ventas de inventario.
const String kSaleDocumentTypeInventory = '01-INVENTARIO';

/// Servicio HTTP del módulo de ventas.
class SalesService {
  SalesService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  static const JsonEncoder _prettyJson = JsonEncoder.withIndent('  ');

  /// POST /docs-emitidos/emitir-documento/{tipoDoc}
  ///
  /// [documentType] por defecto es [kSaleDocumentTypeInventory] (`01-INVENTARIO`).
  /// El body es [CreateSaleRequest].
  Future<CreateSaleResult> createSale(
    CreateSaleRequest request, {
    String documentType = kSaleDocumentTypeInventory,
  }) async {
    final path = '/docs-emitidos/emitir-documento/$documentType';
    final body = request.toJson();

    debugPrint('──── emitir-documento REQUEST ────');
    debugPrint('POST $path');
    debugPrint(_prettyJson.convert(body));
    debugPrint('──────────────────────────────────');

    try {
      final response = await _dio.post(path, data: body);

      final data = response.data as Map<String, dynamic>;
      debugPrint('──── emitir-documento RESPONSE ────');
      debugPrint(_prettyJson.convert(data));
      debugPrint('───────────────────────────────────');

      checkApiStatus(data, showToast: false);

      final raw = data['response'];
      if (raw is Map) {
        return CreateSaleResult.fromJson(Map<String, dynamic>.from(raw));
      }
      return CreateSaleResult.fromJson(data);
    } on DioException catch (e) {
      debugPrint('──── emitir-documento ERROR ────');
      debugPrint('status: ${e.response?.statusCode}');
      debugPrint('payload enviado:');
      debugPrint(_prettyJson.convert(body));
      if (e.response?.data != null) {
        try {
          debugPrint('response:');
          debugPrint(
            e.response!.data is Map || e.response!.data is List
                ? _prettyJson.convert(e.response!.data)
                : e.response!.data.toString(),
          );
        } catch (_) {
          debugPrint('response: ${e.response?.data}');
        }
      }
      debugPrint('────────────────────────────────');
      throwFromDio(e, showToast: false);
    }
  }

  /// GET /ventas/listar
  ///
  /// [query] debe incluir `page` y `amount` (obligatorios).
  /// El resto de params son filtros opcionales.
  Future<ListSalesPageResult> listSales({ListSalesQuery? query}) async {
    final effective = query ?? ListSalesQuery();
    try {
      final response = await _dio.get(
        '/ventas/listar',
        queryParameters: effective.toQueryMap(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return ListSalesPageResult.fromResponse(
        data['response'],
        requestedPage: effective.pageNumber,
        pageSize: effective.pageSize,
      );
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// GET /ventas/{idVenta}
  Future<ListSales> getSaleById(int idVenta) async {
    try {
      final response = await _dio.get('/ventas/$idVenta');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      final raw = data['response'];
      if (raw is Map) {
        return ListSales.fromJson(Map<String, dynamic>.from(raw));
      }
      return ListSales.fromJson(data);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// GET /ventas/resumen
  ///
  /// Params requeridos: `fecha_inicio`, `fecha_fin`, `id_sucursal` (YYYY-MM-DD).
  Future<VentasResumen> getVentasResumen(VentasResumenQuery query) async {
    try {
      final response = await _dio.get(
        '/ventas/resumen',
        queryParameters: query.toQueryMap(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      final raw = data['response'];
      if (raw is Map) {
        return VentasResumen.fromJson(Map<String, dynamic>.from(raw));
      }
      return VentasResumen.fromJson(data);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// GET /ventas/descargar-pdf/{nroDocumento}
  ///
  /// Descarga el PDF de la venta. Devuelve los bytes del archivo.
  Future<Uint8List> downloadSalePdf(String nroDocumento) async {
    final encoded = Uri.encodeComponent(nroDocumento.trim());
    final path = '/ventas/descargar-pdf/$encoded';

    try {
      final response = await _dio.get<List<int>>(
        path,
        options: Options(
          responseType: ResponseType.bytes,
          headers: const {
            'Accept': 'application/pdf',
          },
        ),
      );

      final raw = response.data;
      if (raw == null || raw.isEmpty) {
        throw StateError('El servidor no devolvió el PDF de la venta');
      }

      return Uint8List.fromList(raw);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }
}
