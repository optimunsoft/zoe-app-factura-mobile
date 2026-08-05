// Catálogos comunes de terceros (tipos doc, persona, régimen IVA, responsabilidades).

/// Tipo de documento.
/// API: `{ id, code, type }`
class DocumentTypeItem {
  DocumentTypeItem({
    required this.id,
    required this.code,
    required this.type,
  });

  final int id;
  final int code;
  final String type;

  factory DocumentTypeItem.fromJson(Map<String, dynamic> json) {
    return DocumentTypeItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: (json['code'] as num?)?.toInt() ?? 0,
      type: json['type']?.toString() ?? '',
    );
  }

  static List<DocumentTypeItem> listFromResponse(dynamic response) {
    return _listFromResponse(response, DocumentTypeItem.fromJson);
  }
}

/// Tipo de persona.
/// API: `{ id, code, type }` — `code` viene como string ("1", "2").
class PersonType {
  PersonType({
    required this.id,
    required this.code,
    required this.type,
  });

  final int id;
  final String code;
  final String type;

  factory PersonType.fromJson(Map<String, dynamic> json) {
    return PersonType(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  static List<PersonType> listFromResponse(dynamic response) {
    return _listFromResponse(response, PersonType.fromJson);
  }
}

/// Régimen de IVA.
/// API: `{ id, code, regime }`
class RegimeIva {
  RegimeIva({
    required this.id,
    required this.code,
    required this.regime,
  });

  final int id;
  final String code;
  final String regime;

  factory RegimeIva.fromJson(Map<String, dynamic> json) {
    return RegimeIva(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      regime: json['regime']?.toString() ?? '',
    );
  }

  static List<RegimeIva> listFromResponse(dynamic response) {
    return _listFromResponse(response, RegimeIva.fromJson);
  }
}

/// Responsabilidad fiscal.
/// API: `{ id, code, respnsability }` (typo del backend).
class FiscalResponsibility {
  FiscalResponsibility({
    required this.id,
    required this.code,
    required this.responsibility,
  });

  final int id;
  final String code;
  final String responsibility;

  factory FiscalResponsibility.fromJson(Map<String, dynamic> json) {
    return FiscalResponsibility(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      responsibility: (json['respnsability'] ?? json['responsibility'])
              ?.toString() ??
          '',
    );
  }

  static List<FiscalResponsibility> listFromResponse(dynamic response) {
    return _listFromResponse(response, FiscalResponsibility.fromJson);
  }
}

/// Municipio.
/// API: `{ id, nombre, departamento }`
class Municipality {
  Municipality({
    required this.id,
    required this.nombre,
    required this.departamento,
  });

  final int id;
  final String nombre;
  final String departamento;

  String get label => '$nombre ($departamento)';

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      departamento: json['departamento']?.toString() ?? '',
    );
  }

  static List<Municipality> listFromResponse(dynamic response) {
    return _listFromResponse(response, Municipality.fromJson);
  }
}

List<T> _listFromResponse<T>(
  dynamic response,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (response is List) {
    return response
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  if (response is Map) {
    return [fromJson(Map<String, dynamic>.from(response))];
  }
  return const [];
}
