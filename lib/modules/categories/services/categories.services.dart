import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/categories_models.dart';

class CategoriesService {
  CategoriesService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// GET /categorias
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categorias');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      final raw = data['response'];
      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      // Por si el backend devuelve la lista directa
      if (response.data is List) {
        return (response.data as List)
            .whereType<Map>()
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      return const [];
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }
}
