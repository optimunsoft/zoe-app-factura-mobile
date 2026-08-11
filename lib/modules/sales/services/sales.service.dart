import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/sales.models.dart';

/// Tipo de documento por defecto para ventas de inventario.
const String kSaleDocumentTypeInventory = '01-INVENTARIO';

/// Servicio HTTP del módulo de ventas.
class SalesService {
  SalesService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// POST /docs-emitidos/emitir-documento/{tipoDoc}
  ///
  /// [documentType] por defecto es [kSaleDocumentTypeInventory] (`01-INVENTARIO`).
  /// El body es [CreateSaleRequest].
  Future<Map<String, dynamic>> createSale(
    CreateSaleRequest request, {
    String documentType = kSaleDocumentTypeInventory,
  }) async {
    try {
      final response = await _dio.post(
        '/docs-emitidos/emitir-documento/$documentType',
        data: request.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      final raw = data['response'];
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      return data;
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// Placeholder: listado de ventas (sin endpoint aún).
  Future<List<SaleSummary>> getSales({int? branchId}) async {
    return const <SaleSummary>[];
  }
}
