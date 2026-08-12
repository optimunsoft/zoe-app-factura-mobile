import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../domain/mappers/sales_history_mapper.dart';
import '../domain/models/list_sales.models.dart';
import '../domain/models/sales_history_filters.dart';
import '../domain/models/sales_history_item.dart';
import '../domain/queries/sales_history_query_builder.dart';
import '../services/sales.service.dart';

/// Estado del historial de ventas (listado, paginación, detalle).
class SalesHistoryStore extends ChangeNotifier {
  SalesHistoryStore({SalesService? service}) : _service = service ?? SalesService();

  final SalesService _service;

  bool isLoadingList = false;
  bool isLoadingMore = false;
  bool isLoadingDetail = false;
  String? error;

  List<SaleHistoryItem> items = [];
  SalesHistoryFilters filters = SalesHistoryFilters();

  ListSalesQuery? lastQuery;
  int currentPage = 1;
  int totalPage = 1;
  int totalRecords = 0;
  bool hasMore = false;

  /// Detalle por id (evita pisar estado global con una sola venta).
  final Map<int, ListSales> _detailsById = {};
  String? _detailError;

  ListSales? detailFor(int id) => _detailsById[id];
  String? detailErrorFor(int id) => _detailError;

  /// Recarga desde página 1 con filtros y sucursal obligatoria.
  Future<void> load({
    required String? branchId,
    SalesHistoryFilters? filters,
  }) async {
    if (branchId == null || branchId.isEmpty) {
      error = 'No se pudo determinar la sucursal de la sesión';
      items = [];
      hasMore = false;
      notifyListeners();
      return;
    }

    if (filters != null) {
      this.filters = filters;
    }

    isLoadingList = true;
    isLoadingMore = false;
    error = null;
    lastQuery = SalesHistoryQueryBuilder.build(
      filters: this.filters,
      branchId: branchId,
      page: 1,
    );
    notifyListeners();

    try {
      final result = await _service.listSales(query: lastQuery);
      items = SalesHistoryMapper.toListItems(result.data);
      currentPage = result.currentPage;
      totalPage = result.totalPage;
      totalRecords = result.totalRecords;
      hasMore = result.hasMore;
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
      hasMore = false;
    }

    isLoadingList = false;
    notifyListeners();
  }

  /// Siguiente página (append, deduplicado por id).
  Future<void> loadMore({required String? branchId}) async {
    if (!hasMore || isLoadingMore || isLoadingList) return;
    if (branchId == null || branchId.isEmpty) return;

    final nextPage = currentPage + 1;
    final nextQuery = SalesHistoryQueryBuilder.build(
      filters: filters,
      branchId: branchId,
      page: nextPage,
    );

    isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      final result = await _service.listSales(query: nextQuery);
      lastQuery = nextQuery;
      final existingIds = items.map((e) => e.id).toSet();
      final newItems = SalesHistoryMapper.toListItems(result.data)
          .where((e) => !existingIds.contains(e.id))
          .toList();

      items = [...items, ...newItems];
      currentPage = result.currentPage;
      totalPage = result.totalPage;
      if (result.totalRecords > 0) {
        totalRecords = result.totalRecords;
      }
      hasMore = result.hasMore;
    } catch (e) {
      error = cleanErrorMessage(e);
    }

    isLoadingMore = false;
    notifyListeners();
  }

  /// GET /ventas/{id}
  Future<ListSales?> loadDetail(int saleId) async {
    isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      final sale = await _service.getSaleById(saleId);
      _detailsById[saleId] = sale;
      isLoadingDetail = false;
      notifyListeners();
      return sale;
    } catch (e) {
      _detailError = cleanErrorMessage(e);
      isLoadingDetail = false;
      notifyListeners();
      return null;
    }
  }

  void clear() {
    isLoadingList = false;
    isLoadingMore = false;
    isLoadingDetail = false;
    error = null;
    _detailError = null;
    items = [];
    filters = SalesHistoryFilters();
    lastQuery = null;
    currentPage = 1;
    totalPage = 1;
    totalRecords = 0;
    hasMore = false;
    _detailsById.clear();
    notifyListeners();
  }
}
