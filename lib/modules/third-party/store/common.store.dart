import 'package:flutter/foundation.dart';

import '../../../core/api_helpers.dart';

import '../domain/models/third_party.common.dart';
import '../services/common.services.dart';

/// Store de catálogos common (doc, persona, IVA, fiscal, municipios).
class CommonStore extends ChangeNotifier {
  CommonStore({CommonService? service})
      : _service = service ?? CommonService();

  final CommonService _service;

  List<DocumentTypeItem> documentTypes = [];
  List<PersonType> personTypes = [];
  List<RegimeIva> regimesIva = [];
  List<FiscalResponsibility> fiscalResponsibilities = [];

  List<Municipality> municipalities = [];
  Municipality? selectedMunicipality;
  bool isLoadingMunicipalities = false;
  String? municipalityError;

  bool isLoading = false;
  bool loaded = false;
  String? error;

  Future<void> loadAll() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getDocumentTypes(),
        _service.getPersonTypes(),
        _service.getRegimeIva(),
        _service.getFiscalResponsibilities(),
      ]);

      documentTypes = results[0] as List<DocumentTypeItem>;
      personTypes = results[1] as List<PersonType>;
      regimesIva = results[2] as List<RegimeIva>;
      fiscalResponsibilities = results[3] as List<FiscalResponsibility>;
      loaded = true;
    } catch (e) {
      error = cleanErrorMessage(e);
      loaded = false;
    }

    isLoading = false;
    notifyListeners();
  }

  /// GET /terceros/municipio/{nombre}
  Future<void> searchMunicipalities(String nombre) async {
    final query = nombre.trim();
    if (query.isEmpty) {
      municipalities = [];
      municipalityError = null;
      notifyListeners();
      return;
    }

    isLoadingMunicipalities = true;
    municipalityError = null;
    notifyListeners();

    try {
      municipalities = await _service.getMunicipalities(query);
    } catch (e) {
      municipalityError = cleanErrorMessage(e);
      municipalities = [];
    }

    isLoadingMunicipalities = false;
    notifyListeners();
  }

  void selectMunicipality(Municipality? municipality) {
    selectedMunicipality = municipality;
    if (municipality != null) {
      municipalities = [];
    }
    notifyListeners();
  }

  void clearError() {
    if (error == null) return;
    error = null;
    notifyListeners();
  }
}
