import 'package:dio/dio.dart';

import '../../../core/api_helpers.dart';
import '../../../core/auth/api_client.dart';
import '../domain/models/third_party.common.dart';

/// Catálogos comunes (solo GET).
class CommonService {
  CommonService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// Tipos de documento
  Future<List<DocumentTypeItem>> getDocumentTypes() async {
    try {
      final response = await _dio.get('/terceros/tipo-documento');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return DocumentTypeItem.listFromResponse(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// Tipos de persona (natural / jurídica)
  Future<List<PersonType>> getPersonTypes() async {
    try {
      final response = await _dio.get('/terceros/tipo-persona');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return PersonType.listFromResponse(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// Régimenes de IVA
  Future<List<RegimeIva>> getRegimeIva() async {
    try {
      final response = await _dio.get('/terceros/regimen-iva');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return RegimeIva.listFromResponse(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// Responsabilidades fiscales
  Future<List<FiscalResponsibility>> getFiscalResponsibilities() async {
    try {
      final response = await _dio.get('/terceros/resp-fiscal');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return FiscalResponsibility.listFromResponse(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }

  /// Municipios por nombre
  /// GET /terceros/municipio/{nombre}
  Future<List<Municipality>> getMunicipalities(String nombre) async {
    try {
      final encoded = Uri.encodeComponent(nombre.trim());
      final response = await _dio.get('/terceros/municipio/$encoded');

      final data = response.data as Map<String, dynamic>;
      checkApiStatus(data);

      return Municipality.listFromResponse(data['response']);
    } on DioException catch (e) {
      throwFromDio(e);
    }
  }
}
