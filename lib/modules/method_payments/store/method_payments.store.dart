import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';

import '../domain/models/method_payments.models.dart';
import '../services/method_payments.service.dart';

class MethodPaymentsStore extends ChangeNotifier {
  MethodPaymentsStore({MethodPaymentsService? service})
      : _service = service ?? MethodPaymentsService();

  final MethodPaymentsService _service;

  List<MethodPayment> items = [];
  MethodPayment? selected;
  bool isLoading = false;
  String? error;

  Future<void> loadAll() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      items = await _service.getAll();
      selected ??= items.isNotEmpty ? items.first : null;
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
      selected = null;
    }

    isLoading = false;
    notifyListeners();
  }

  void select(MethodPayment? item) {
    selected = item;
    notifyListeners();
  }

  void clear() {
    items = [];
    selected = null;
    error = null;
    notifyListeners();
  }
}
