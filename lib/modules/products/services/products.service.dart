import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/products.models.dart';

class ProductsService {
  ProductsService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// GET /producto/inventory/branch?id_sucursal=
  Future<List<Product>> getProducts({required ProductQuery query}) async {
    try {
      final response = await _dio.get(
        '/producto/inventory/branch',
        queryParameters: query.toQueryMap(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return _parseList(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  List<Product> _parseList(dynamic raw) {
    if (raw is Map) {
      final list = raw['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return const [];
  }
}
