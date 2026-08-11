import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/taxes.models.dart';

class TaxesService {
  TaxesService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// GET /retencion/getAll
  Future<List<TaxRetention>> getAll({TaxesQuery? query}) async {
    try {
      final response = await _dio.get(
        '/retencion/getAll',
        queryParameters: (query ?? TaxesQuery()).toQueryMap(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return _parseList(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  List<TaxRetention> _parseList(dynamic raw) {
    if (raw is Map) {
      final list = raw['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => TaxRetention.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => TaxRetention.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return const [];
  }
}
