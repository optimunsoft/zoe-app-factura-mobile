import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';

import '../domain/models/third_party_models.dart';
import '../services/thirdparty.service.dart';

class ThirdPartyStore extends ChangeNotifier {
  ThirdPartyStore({ThirdPartyService? service})
      : _service = service ?? ThirdPartyService();

  final ThirdPartyService _service;

  List<ThirdParty> items = [];
  ThirdParty? selected;
  bool isLoading = false;
  String? error;

  int currentPage = 1;
  int totalPage = 1;
  int totalRecords = 0;

  Future<void> loadThirdParties({ThirdPartyQuery? query}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _service.getThirdParties(query: query);
      items = result.data;
      currentPage = result.currentPage;
      totalPage = result.totalPage;
      totalRecords = result.totalRecords;
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Busca por NIT/documento, razón social o persona de contacto (OR).
  Future<void> searchByAny(String raw) async {
    final text = raw.trim();
    if (text.isEmpty) {
      await loadThirdParties(
        query: ThirdPartyQuery(page: '1', amount: '15'),
      );
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    final digits = text.replaceAll(RegExp(r'[\s.\-]'), '');
    final isDocument = digits.isNotEmpty && RegExp(r'^\d+$').hasMatch(digits);

    final queries = <ThirdPartyQuery>[
      ThirdPartyQuery(page: '1', amount: '15', companyName: text),
      ThirdPartyQuery(page: '1', amount: '15', contactPerson: text),
      if (isDocument)
        ThirdPartyQuery(
          page: '1',
          amount: '15',
          identificationNumber: digits,
        ),
    ];

    try {
      final results = await Future.wait(
        queries.map((q) => _service.getThirdParties(query: q)),
      );

      final byId = <int, ThirdParty>{};
      for (final result in results) {
        for (final item in result.data) {
          byId[item.id] = item;
        }
      }

      items = byId.values.toList();
      currentPage = 1;
      totalPage = 1;
      totalRecords = items.length;
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadById(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      selected = await _service.getById(id);
    } catch (e) {
      error = cleanErrorMessage(e);
      selected = null;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<ThirdParty?> create(ThirdPartyPayload payload) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      selected = await _service.create(payload);
      items = [selected!, ...items];
      isLoading = false;
      notifyListeners();
      return selected;
    } catch (e) {
      error = cleanErrorMessage(e);
      selected = null;
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clear() {
    items = [];
    selected = null;
    error = null;
    notifyListeners();
  }
}