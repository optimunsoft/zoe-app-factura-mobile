import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../domain/models/list_sales.models.dart';
import '../domain/models/sales.models.dart';
import '../services/sales.service.dart';

/// Estado del módulo de ventas (inyectable vía Provider).
class SalesStore extends ChangeNotifier {
  SalesStore({SalesService? service}) : _service = service ?? SalesService();

  final SalesService _service;

  bool isLoading = false;
  bool isLoadingList = false;
  bool isLoadingMore = false;
  bool isLoadingDetail = false;
  String? error;

  /// Último body enviado a emitir-documento.
  CreateSaleRequest? lastRequest;

  /// Respuesta tipada del backend (`response` del envelope).
  CreateSaleResult? lastResult;

  /// Listado de ventas (`GET /ventas/listar`).
  List<ListSales> items = [];

  /// Venta seleccionada / detalle (`GET /ventas/{id}`).
  ListSales? selected;

  /// Última query usada en el listado.
  ListSalesQuery? lastQuery;

  int currentPage = 1;
  int totalPage = 1;
  int totalRecords = 0;
  bool hasMore = false;

  /// POST /docs-emitidos/emitir-documento/{tipoDoc}
  ///
  /// Retorna el resultado tipado o `null` si falla.
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
      error = cleanErrorMessage(e);
      lastResult = null;
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// GET /ventas/listar — recarga desde página 1 con amount inicial (reemplaza items).
  Future<void> loadListSales({ListSalesQuery? query}) async {
    isLoadingList = true;
    isLoadingMore = false;
    error = null;
    final base = query ?? ListSalesQuery();
    lastQuery = base.copyWith(
      page: '1',
      amount: base.amount.isEmpty ? '10' : base.amount,
    );
    notifyListeners();

    try {
      final result = await _service.listSales(query: lastQuery);
      items = result.data;
      currentPage = result.currentPage;
      totalPage = result.totalPage;
      totalRecords = result.totalRecords;
      // Mostrar "Cargar más" si hay ventas; se apaga solo cuando
      // ampliar amount no trae registros nuevos.
      hasMore = items.isNotEmpty;
      debugPrint(
        'listSales: items=${items.length} amount=${lastQuery!.amount} '
        'totalRecords=$totalRecords hasMore=$hasMore',
      );
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
      currentPage = 1;
      totalPage = 1;
      totalRecords = 0;
      hasMore = false;
    }

    isLoadingList = false;
    notifyListeners();
  }

  /// Suma 10 al `amount` y vuelve a pedir el listado (page=1).
  Future<void> loadMoreListSales() async {
    if (isLoadingMore || isLoadingList) return;

    final base = lastQuery ?? ListSalesQuery();
    final currentAmount = int.tryParse(base.amount) ?? 10;
    final nextAmount = currentAmount + 10;
    final nextQuery = base.copyWith(page: '1', amount: '$nextAmount');

    isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      final previousCount = items.length;
      final result = await _service.listSales(query: nextQuery);
      lastQuery = nextQuery;
      items = result.data;
      currentPage = result.currentPage;
      totalPage = result.totalPage;
      if (result.totalRecords > 0) {
        totalRecords = result.totalRecords;
      }
      hasMore = items.length > previousCount;
      debugPrint(
        'loadMore: prev=$previousCount now=${items.length} '
        'amount=$nextAmount hasMore=$hasMore',
      );
    } catch (e) {
      error = cleanErrorMessage(e);
    }

    isLoadingMore = false;
    notifyListeners();
  }

  /// GET /ventas/{idVenta}
  Future<ListSales?> loadSaleById(int idVenta) async {
    isLoadingDetail = true;
    error = null;
    notifyListeners();

    try {
      selected = await _service.getSaleById(idVenta);
      isLoadingDetail = false;
      notifyListeners();
      return selected;
    } catch (e) {
      error = cleanErrorMessage(e);
      selected = null;
      isLoadingDetail = false;
      notifyListeners();
      return null;
    }
  }

  void select(ListSales? item) {
    selected = item;
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  void clear() {
    isLoading = false;
    isLoadingList = false;
    isLoadingMore = false;
    isLoadingDetail = false;
    error = null;
    lastRequest = null;
    lastResult = null;
    items = [];
    selected = null;
    lastQuery = null;
    currentPage = 1;
    totalPage = 1;
    totalRecords = 0;
    hasMore = false;
    notifyListeners();
  }
}
