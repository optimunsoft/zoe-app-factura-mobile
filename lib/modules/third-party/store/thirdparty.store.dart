import 'package:flutter/foundation.dart';

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
      error = e.toString().replaceFirst('Exception: ', '');
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
      error = e.toString().replaceFirst('Exception: ', '');
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
      error = e.toString().replaceFirst('Exception: ', '');
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