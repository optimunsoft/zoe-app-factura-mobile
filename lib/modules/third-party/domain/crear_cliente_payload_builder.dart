import '../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../modules/third-party/domain/models/third_party_models.dart';

/// Construye el payload de creación de cliente a partir del estado del formulario.
abstract final class CrearClientePayloadBuilder {
  static ThirdPartyPayload build({
    required bool foreign,
    required bool freeZone,
    required bool zomac,
    required String identificationNumber,
    required int documentTypeId,
    required String? verificationDigit,
    required String? personTypeCode,
    required bool isNatural,
    required String companyName,
    required String firstName,
    required String middleName,
    required String lastName,
    required String secondLastName,
    required String contactPerson,
    required String observations,
    required Municipality municipality,
    required String address,
    required String email,
    required String phone1,
    required String phone2,
    required String? vatRegimeCode,
    required String? fiscalRespCode,
  }) {
    final obs = observations.trim();
    return ThirdPartyPayload(
      typeThird: 'CLIENTE',
      foreign: foreign,
      freeZone: freeZone,
      zomac: zomac,
      identificationNumber: identificationNumber.trim(),
      documentTypeId: documentTypeId,
      verificationDigit:
          (verificationDigit == null || verificationDigit.trim().isEmpty)
              ? null
              : verificationDigit.trim(),
      personTypeCode: personTypeCode,
      companyName: isNatural ? '' : companyName.trim(),
      firstName: isNatural ? firstName.trim() : '',
      middleName: isNatural ? middleName.trim() : '',
      lastName: isNatural ? lastName.trim() : '',
      secondLastName: isNatural ? secondLastName.trim() : '',
      contactPerson: contactPerson.trim(),
      observations: obs.isEmpty ? 'sin observaciones' : obs,
      municipalityId: municipality.id,
      countryId: null,
      address: address.trim(),
      email: email.trim(),
      phone1: phone1.trim(),
      phone2: phone2.trim(),
      vatRegimeCode: vatRegimeCode,
      fiscalRespCode: fiscalRespCode,
    );
  }
}
