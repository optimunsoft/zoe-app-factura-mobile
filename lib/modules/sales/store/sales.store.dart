import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../domain/models/sales.models.dart';
import '../services/sales.service.dart';

/// Estado del módulo de ventas (inyectable vía Provider).
class SalesStore extends ChangeNotifier {
  SalesStore({SalesService? service}) : _service = service ?? SalesService();

  final SalesService _service;

  bool isLoading = false;
  String? error;

  /// Último body enviado a emitir-documento.
  CreateSaleRequest? lastRequest;

  /// Respuesta cruda del backend (`response` del envelope).
  Map<String, dynamic>? lastResponse;

  /// POST /docs-emitidos/emitir-documento/{tipoDoc}
  ///
  /// Retorna el `response` del API o `null` si falla.
  Future<Map<String, dynamic>?> createSale(
    CreateSaleRequest request, {
    String documentType = kSaleDocumentTypeInventory,
  }) async {
    isLoading = true;
    error = null;
    lastRequest = request;
    lastResponse = null;
    notifyListeners();

    try {
      lastResponse = await _service.createSale(
        request,
        documentType: documentType,
      );
      isLoading = false;
      notifyListeners();
      return lastResponse;
    } catch (e) {
      error = cleanErrorMessage(e);
      lastResponse = null;
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  void clear() {
    isLoading = false;
    error = null;
    lastRequest = null;
    lastResponse = null;
    notifyListeners();
  }
}
