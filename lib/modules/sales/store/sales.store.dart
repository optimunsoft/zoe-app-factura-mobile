import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../../../core/app_toast.dart';
import '../domain/models/ingresos_medios_pago.models.dart';
import '../domain/models/sales.models.dart';
import '../domain/models/ventas_resumen.models.dart';
import '../services/sales.service.dart';

/// Estado de creación de ventas (checkout / emitir documento),
/// descarga de PDF, resumen y reportes de ventas.
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

  /// Estado de GET /ventas/resumen.
  bool isLoadingResumen = false;
  String? resumenError;
  VentasResumenQuery? lastResumenQuery;
  VentasResumen resumen = VentasResumen.empty;

  /// Estado de GET /ventas/reportes/ingresos-medios-pago.
  bool isLoadingIngresosMediosPago = false;
  String? ingresosMediosPagoError;
  IngresosMediosPagoQuery? lastIngresosMediosPagoQuery;
  List<IngresoMedioPagoItem> ingresosMediosPago = const [];

  /// Estado de GET /ventas/reportes/ingresos-medios-pago/pdf.
  bool isDownloadingIngresosMediosPagoPdf = false;
  String? ingresosMediosPagoPdfError;
  Uint8List? lastIngresosMediosPagoPdfBytes;

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

  /// GET /ventas/resumen — params: fecha_inicio, fecha_fin, id_sucursal.
  Future<VentasResumen?> loadVentasResumen(VentasResumenQuery query) async {
    final start = query.startDate.trim();
    final end = query.endDate.trim();
    final branchId = query.branchId.trim();

    if (start.isEmpty || end.isEmpty || branchId.isEmpty) {
      resumenError = 'fecha_inicio, fecha_fin e id_sucursal son obligatorios';
      resumen = VentasResumen.empty;
      notifyListeners();
      return null;
    }

    isLoadingResumen = true;
    resumenError = null;
    lastResumenQuery = VentasResumenQuery(
      startDate: start,
      endDate: end,
      branchId: branchId,
    );
    notifyListeners();

    try {
      resumen = await _service.getVentasResumen(lastResumenQuery!);
      isLoadingResumen = false;
      notifyListeners();
      return resumen;
    } catch (e) {
      resumenError = cleanErrorMessage(e);
      resumen = VentasResumen.empty;
      isLoadingResumen = false;
      notifyListeners();
      return null;
    }
  }

  /// GET /ventas/reportes/ingresos-medios-pago
  /// — params: id_sucursal, fecha_inicio, fecha_fin.
  Future<List<IngresoMedioPagoItem>?> loadIngresosMediosPago(
    IngresosMediosPagoQuery query,
  ) async {
    final start = query.startDate.trim();
    final end = query.endDate.trim();
    final branchId = query.branchId.trim();

    if (start.isEmpty || end.isEmpty || branchId.isEmpty) {
      ingresosMediosPagoError =
          'fecha_inicio, fecha_fin e id_sucursal son obligatorios';
      ingresosMediosPago = const [];
      notifyListeners();
      return null;
    }

    isLoadingIngresosMediosPago = true;
    ingresosMediosPagoError = null;
    lastIngresosMediosPagoQuery = IngresosMediosPagoQuery(
      startDate: start,
      endDate: end,
      branchId: branchId,
    );
    notifyListeners();

    try {
      ingresosMediosPago = await _service.getIngresosMediosPago(
        lastIngresosMediosPagoQuery!,
      );
      isLoadingIngresosMediosPago = false;
      notifyListeners();
      return ingresosMediosPago;
    } catch (e) {
      ingresosMediosPagoError = cleanErrorMessage(e);
      ingresosMediosPago = const [];
      isLoadingIngresosMediosPago = false;
      notifyListeners();
      return null;
    }
  }

  /// GET /ventas/reportes/ingresos-medios-pago/pdf
  /// — params: id_sucursal, fecha_inicio, fecha_fin.
  Future<Uint8List?> downloadIngresosMediosPagoPdf(
    IngresosMediosPagoQuery query,
  ) async {
    final start = query.startDate.trim();
    final end = query.endDate.trim();
    final branchId = query.branchId.trim();

    if (start.isEmpty || end.isEmpty || branchId.isEmpty) {
      ingresosMediosPagoPdfError =
          'fecha_inicio, fecha_fin e id_sucursal son obligatorios';
      lastIngresosMediosPagoPdfBytes = null;
      notifyListeners();
      return null;
    }

    isDownloadingIngresosMediosPagoPdf = true;
    ingresosMediosPagoPdfError = null;
    lastIngresosMediosPagoPdfBytes = null;
    notifyListeners();

    try {
      lastIngresosMediosPagoPdfBytes =
          await _service.downloadIngresosMediosPagoPdf(
        IngresosMediosPagoQuery(
          startDate: start,
          endDate: end,
          branchId: branchId,
        ),
      );
      isDownloadingIngresosMediosPagoPdf = false;
      notifyListeners();
      return lastIngresosMediosPagoPdfBytes;
    } catch (e) {
      ingresosMediosPagoPdfError = cleanErrorMessage(e);
      lastIngresosMediosPagoPdfBytes = null;
      isDownloadingIngresosMediosPagoPdf = false;
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

  void clearResumen() {
    isLoadingResumen = false;
    resumenError = null;
    lastResumenQuery = null;
    resumen = VentasResumen.empty;
    notifyListeners();
  }

  void clearIngresosMediosPago() {
    isLoadingIngresosMediosPago = false;
    ingresosMediosPagoError = null;
    lastIngresosMediosPagoQuery = null;
    ingresosMediosPago = const [];
    isDownloadingIngresosMediosPagoPdf = false;
    ingresosMediosPagoPdfError = null;
    lastIngresosMediosPagoPdfBytes = null;
    notifyListeners();
  }

  void clear() {
    isLoading = false;
    error = null;
    lastRequest = null;
    lastResult = null;
    clearPdf();
    clearResumen();
    clearIngresosMediosPago();
  }
}
