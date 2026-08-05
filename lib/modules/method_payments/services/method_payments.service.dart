import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/method_payments.models.dart';

class MethodPaymentsService {
  MethodPaymentsService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// GET /mediopago/getAll
  Future<List<MethodPayment>> getAll() async {
    try {
      final response = await _dio.get('/mediopago/getAll');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return _parseList(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }



  List<MethodPayment> _parseList(dynamic raw) {
    if (raw is Map) {
      final list = raw['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => MethodPayment.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => MethodPayment.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return const [];
  }
}
