import 'third_party_base.dart';

export 'third_party_base.dart';

// Modelos de terceros (query, response, payload).

/// Query params de la consulta de terceros.
class ThirdPartyQuery {
  ThirdPartyQuery({
    this.page = '1',
    this.amount = '10',
    this.identificationNumber,
    this.companyName,
    this.contactPerson,
  });

  final String page;
  final String amount;
  final String? identificationNumber;
  final String? companyName;
  final String? contactPerson;

  Map<String, dynamic> toQueryMap() {
    return {
      'page': page,
      'amount': amount,
      if (identificationNumber != null && identificationNumber!.isNotEmpty)
        'identificationNumber': identificationNumber,
      if (companyName != null && companyName!.isNotEmpty)
        'companyName': companyName,
      if (contactPerson != null && contactPerson!.isNotEmpty)
        'contactPerson': contactPerson,
    };
  }
}

class DocumentTypeInfo {
  DocumentTypeInfo({required this.id, required this.code, required this.type});

  final int id;
  final int code;
  final String type;

  factory DocumentTypeInfo.fromJson(Map<String, dynamic> json) {
    return DocumentTypeInfo(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: (json['code'] as num?)?.toInt() ?? 0,
      type: json['type']?.toString() ?? '',
    );
  }
}

/// Respuesta GET/POST: suma id, companyId, documentType(Id), ubicación y fechas.
class ThirdParty extends ThirdPartyBase {
  ThirdParty({
    required this.id,
    required super.typeThird,
    required super.foreign,
    required super.freeZone,
    required super.zomac,
    required super.identificationNumber,
    super.verificationDigit,
    super.personTypeCode,
    super.companyName,
    super.firstName,
    super.middleName,
    super.lastName,
    super.secondLastName,
    super.contactPerson,
    super.observations,
    super.municipalityId,
    super.countryId,
    super.address,
    super.email,
    super.phone1,
    super.phone2,
    super.vatRegimeCode,
    super.fiscalRespCode,
    this.companyId,
    this.documentTypeId,
    this.countryName,
    this.state,
    this.city,
    this.createdAt,
    this.updatedAt,
    this.documentType,
  });

  final int id;
  final int? companyId;
  final int? documentTypeId;
  final String? countryName;
  final String? state;
  final String? city;
  final String? createdAt;
  final String? updatedAt;
  final DocumentTypeInfo? documentType;

  factory ThirdParty.fromJson(Map<String, dynamic> json) {
    final doc = json['documentType'];
    return ThirdParty(
      id: (json['id'] as num?)?.toInt() ?? 0,
      companyId: (json['companyId'] as num?)?.toInt(),
      documentTypeId: (json['documentTypeId'] as num?)?.toInt(),
      typeThird: json['typeThird']?.toString() ?? '',
      foreign: json['foreign'] == true,
      freeZone: json['freeZone'] == true,
      zomac: json['zomac'] == true,
      identificationNumber: json['identificationNumber']?.toString() ?? '',
      verificationDigit: json['verificationDigit']?.toString(),
      personTypeCode: json['personTypeCode']?.toString(),
      companyName: json['companyName']?.toString(),
      firstName: json['firstName']?.toString(),
      middleName: json['middleName']?.toString(),
      lastName: json['lastName']?.toString(),
      secondLastName: json['secondLastName']?.toString(),
      contactPerson: json['contactPerson']?.toString(),
      observations: json['observations']?.toString(),
      municipalityId: (json['municipalityId'] as num?)?.toInt(),
      countryId: (json['countryId'] as num?)?.toInt(),
      address: json['address']?.toString(),
      email: json['email']?.toString(),
      phone1: json['phone1']?.toString(),
      phone2: json['phone2']?.toString(),
      vatRegimeCode: json['vatRegimeCode']?.toString(),
      fiscalRespCode: json['fiscalRespCode']?.toString(),
      countryName: json['countryName']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      documentType: doc is Map<String, dynamic>
          ? DocumentTypeInfo.fromJson(doc)
          : null,
    );
  }
}

/// Body POST/PUT: mismos campos base + `documentTypeId`.
class ThirdPartyPayload extends ThirdPartyBase {
  ThirdPartyPayload({
    required super.typeThird,
    required super.foreign,
    required super.freeZone,
    required super.zomac,
    required super.identificationNumber,
    required this.documentTypeId,
    super.verificationDigit,
    super.personTypeCode,
    super.companyName,
    super.firstName,
    super.middleName,
    super.lastName,
    super.secondLastName,
    super.contactPerson,
    super.observations,
    super.municipalityId,
    super.countryId,
    super.address,
    super.email,
    super.phone1,
    super.phone2,
    super.vatRegimeCode,
    super.fiscalRespCode,
  });

  final int documentTypeId;

  Map<String, dynamic> toJson() {
    return {...baseToJson(), 'documentTypeId': documentTypeId};
  }
}

/// Envelope: status + message + response (paginación + data).
class ThirdPartyListResult {
  ThirdPartyListResult({
    required this.status,
    required this.message,
    required this.currentPage,
    required this.totalPage,
    required this.totalRecords,
    required this.limit,
    required this.data,
  });

  final bool status;
  final String message;
  final int currentPage;
  final int totalPage;
  final int totalRecords;
  final int limit;
  final List<ThirdParty> data;

  factory ThirdPartyListResult.fromJson(Map<String, dynamic> json) {
    final response = json['response'] as Map<String, dynamic>? ?? {};
    final raw = response['data'];
    final list = raw is List
        ? raw
              .whereType<Map<String, dynamic>>()
              .map(ThirdParty.fromJson)
              .toList()
        : <ThirdParty>[];

    return ThirdPartyListResult(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      currentPage: (response['current_page'] as num?)?.toInt() ?? 1,
      totalPage: (response['total_page'] as num?)?.toInt() ?? 1,
      totalRecords: (response['total_records'] as num?)?.toInt() ?? 0,
      limit: (response['limit'] as num?)?.toInt() ?? 15,
      data: list,
    );
  }
}
