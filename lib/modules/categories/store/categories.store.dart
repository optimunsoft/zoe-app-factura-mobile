import 'package:flutter/foundation.dart' hide Category;

import '../../../core/api_helpers.dart';

import '../domain/models/categories_models.dart';
import '../services/categories.services.dart';

class CategoriesStore extends ChangeNotifier {
  CategoriesStore({CategoriesService? service})
      : _service = service ?? CategoriesService();

  final CategoriesService _service;

  List<Category> items = [];
  bool isLoading = false;
  String? error;

  Future<void> loadCategories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      items = await _service.getCategories();
    } catch (e) {
      error = cleanErrorMessage(e);
      items = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
