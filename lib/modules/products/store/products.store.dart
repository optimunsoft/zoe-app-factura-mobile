import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';

import '../domain/models/products.models.dart';
import '../services/products.service.dart';

class ProductsStore extends ChangeNotifier {
  ProductsStore({ProductsService? service})
      : _service = service ?? ProductsService();

  final ProductsService _service;

  /// Respuesta completa de la API (sin filtros locales).
  List<Product> _allItems = [];

  /// Lista visible (categoría + búsqueda local).
  List<Product> items = [];

  int? selectedCategoryId;
  String searchQuery = '';
  bool isLoading = false;
  String? error;
  ProductQuery? lastQuery;

  Future<void> loadProducts({required ProductQuery query}) async {
    isLoading = true;
    error = null;
    lastQuery = query;
    notifyListeners();

    try {
      _allItems = await _service.getProducts(query: query);
      _applyFilters();
    } catch (e) {
      error = cleanErrorMessage(e);
      _allItems = [];
      items = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Filtra por categoría en memoria (sin llamar a la API).
  void setCategoryFilter(int? categoryId) {
    selectedCategoryId = categoryId;
    _applyFilters();
    notifyListeners();
  }

  /// Filtra por nombre o código de barras en memoria (sin llamar a la API).
  void setSearchQuery(String query) {
    searchQuery = query.trim();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    Iterable<Product> filtered = _allItems;

    if (selectedCategoryId != null) {
      filtered = filtered.where((p) => p.category.id == selectedCategoryId);
    }

    final q = searchQuery.toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((p) {
        final name = p.name.toLowerCase();
        final barcode = p.barcode.toLowerCase();
        return name.contains(q) || barcode.contains(q);
      });
    }

    items = filtered.toList();
  }

  void clear() {
    _allItems = [];
    items = [];
    selectedCategoryId = null;
    searchQuery = '';
    error = null;
    lastQuery = null;
    notifyListeners();
  }
}
