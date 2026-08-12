import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../../../core/app_toast.dart';
import '../domain/models/sales.models.dart';
import '../services/sales.service.dart';

/// Estado de creación de ventas (checkout / emitir documento)
/// y descarga de PDF de venta.
class SalesStore extends ChangeNotifier {
  SalesStore({SalesService? service}) : _service = service ?? SalesService();

  final SalesService _service;

  bool isLoading = false;
  String? error;

  CreateSaleRequest? lastRequest;
  CreateSaleResult? lastResult;

  /// Estado de GET /ventas/descargar-pdf/{nroDocumento}.
  bool isDownloadingPdf = false;
  String? pdfError;
  String? lastPdfDocumentNumber;
  Uint8List? lastPdfBytes;

  Future<CreateSaleResult?> createSale(
    CreateSaleRequest request, {
    String documentType = kSaleDocumentTypeInventory,
  }) async {
    isLoading = true;
    error = null;
    lastRequest = request;
    lastResult = null;
    notifyListeners();

    try {
      lastResult = await _service.createSale(
        request,
        documentType: documentType,
      );
      isLoading = false;
      notifyListeners();
      return lastResult;
    } catch (e) {
      final message = cleanErrorMessage(e);
      error = message.isNotEmpty
          ? message
          : 'No se pudo emitir el documento';
      AppToast.error(error!);
      lastResult = null;
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Descarga el PDF de una venta por número de documento.
  ///
  /// Guarda el resultado en [lastPdfBytes]. Devuelve `null` si falla.
  Future<Uint8List?> downloadSalePdf(String nroDocumento) async {
    final documentNumber = nroDocumento.trim();
    if (documentNumber.isEmpty) {
      pdfError = 'Número de documento inválido';
      lastPdfBytes = null;
      lastPdfDocumentNumber = null;
      notifyListeners();
      return null;
    }

    isDownloadingPdf = true;
    pdfError = null;
    lastPdfBytes = null;
    lastPdfDocumentNumber = documentNumber;
    notifyListeners();

    try {
      lastPdfBytes = await _service.downloadSalePdf(documentNumber);
      isDownloadingPdf = false;
      notifyListeners();
      return lastPdfBytes;
    } catch (e) {
      pdfError = cleanErrorMessage(e);
      lastPdfBytes = null;
      isDownloadingPdf = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  void clearPdf() {
    isDownloadingPdf = false;
    pdfError = null;
    lastPdfDocumentNumber = null;
    lastPdfBytes = null;
    notifyListeners();
  }

  void clear() {
    isLoading = false;
    error = null;
    lastRequest = null;
    lastResult = null;
    clearPdf();
  }
}
