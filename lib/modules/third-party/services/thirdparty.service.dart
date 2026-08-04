import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/third_party_models.dart';

class ThirdPartyService {
  ThirdPartyService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// GET /terceros — listado / buscador
  Future<ThirdPartyListResult> getThirdParties({
    ThirdPartyQuery? query,
  }) async {
    try {
      final response = await _dio.get(
        '/terceros',
        queryParameters: (query ?? ThirdPartyQuery()).toQueryMap(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data, fallback: 'Error al consultar terceros');

      return ThirdPartyListResult.fromJson(data);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// GET /terceros/:id — detalle
  Future<ThirdParty> getById(int id) async {


    try {
      final response = await _dio.get('/terceros/$id');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data, fallback: 'Error al consultar el tercero');

      final item = data['response'] as Map<String, dynamic>;
      return ThirdParty.fromJson(item);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// POST /terceros — crear
  Future<ThirdParty> create(ThirdPartyPayload payload) async {
    try {
      final response = await _dio.post(
        '/terceros',
        data: payload.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data, fallback: 'Error al crear el tercero');

      final item = data['response'] as Map<String, dynamic>;
      return ThirdParty.fromJson(item);
    } on DioException catch (e) {
      throwFromDio(e);
    }


  }
}
