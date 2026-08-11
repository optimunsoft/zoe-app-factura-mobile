import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';
import '../domain/models/taxes.models.dart';
import '../services/taxes.service.dart';

class TaxesStore extends ChangeNotifier {
  TaxesStore({TaxesService? service}) : _service = service ?? TaxesService();

  final TaxesService _service;

  List<TaxRetention> items = [];
  TaxRetention? selected;
  bool isLoading = false;
  String? error;
  TaxesQuery? lastQuery;

  /// ReteIVA — `retention.code == 05`.
  List<TaxRetention> get reteIvaOptions => items
      .where((e) => e.retention.isReteIva)
      .toList(growable: false);

  /// ReteFuente — `retention.code == 06`.
  List<TaxRetention> get reteFuenteOptions => items
      .where((e) => e.retention.isReteFuente)
      .toList(growable: false);

  /// ReteICA — `retention.code == 07`.
  List<TaxRetention> get reteIcaOptions => items
      .where((e) => e.retention.isReteIca)
      .toList(growable: false);

  Future<void> loadAll({TaxesQuery? query}) async {
    isLoading = true;
    error = null;
    lastQuery = query ?? TaxesQuery();
    notifyListeners();

    try {
      items = await _service.getAll(query: lastQuery);
      selected ??= items.isNotEmpty ? items.first : null;
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
      selected = null;
    }

    isLoading = false;
    notifyListeners();
  }

  void select(TaxRetention? item) {
    selected = item;
    notifyListeners();
  }

  void clear() {
    items = [];
    selected = null;
    error = null;
    lastQuery = null;
    notifyListeners();
  }
}
