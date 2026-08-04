/// Campos comunes de tercero (request y response).
class ThirdPartyBase {
  ThirdPartyBase({
    required this.typeThird,
    required this.foreign,
    required this.freeZone,
    required this.zomac,
    required this.identificationNumber,
    this.verificationDigit,
    this.personTypeCode,
    this.companyName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.secondLastName,
    this.contactPerson,
    this.observations,
    this.municipalityId,
    this.countryId,
    this.address,
    this.email,
    this.phone1,
    this.phone2,
    this.vatRegimeCode,
    this.fiscalRespCode,
  });

  final String typeThird;
  final bool foreign;
  final bool freeZone;
  final bool zomac;
  final String identificationNumber;
  final String? verificationDigit;
  final String? personTypeCode;
  final String? companyName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? secondLastName;
  final String? contactPerson;
  final String? observations;
  final int? municipalityId;
  final int? countryId;
  final String? address;
  final String? email;
  final String? phone1;
  final String? phone2;
  final String? vatRegimeCode;
  final String? fiscalRespCode;

  String get displayName {
    if (companyName != null && companyName!.trim().isNotEmpty) {
      return companyName!.trim();
    }
    return [firstName, middleName, lastName, secondLastName]
        .where((p) => p != null && p.trim().isNotEmpty)
        .join(' ')
        .trim();
  }

  /// Campos comunes para armar un body JSON.
  Map<String, dynamic> baseToJson() {
    return {
      'typeThird': typeThird,
      'foreign': foreign,
      'freeZone': freeZone,
      'zomac': zomac,
      'identificationNumber': identificationNumber,
      'verificationDigit': verificationDigit,
      'personTypeCode': personTypeCode,
      'companyName': companyName ?? '',
      'firstName': firstName ?? '',
      'middleName': middleName ?? '',
      'lastName': lastName ?? '',
      'secondLastName': secondLastName ?? '',
      'contactPerson': contactPerson,
      'observations': observations,
      'municipalityId': municipalityId,
      'countryId': countryId,
      'address': address,
      'email': email,
      'phone1': phone1,
      'phone2': phone2 ?? '',
      'vatRegimeCode': vatRegimeCode,
      'fiscalRespCode': fiscalRespCode,
    };
  }
}
