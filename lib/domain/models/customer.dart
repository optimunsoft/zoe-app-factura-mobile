class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.documentType,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.address,
    this.city = '',
    this.taxId,
    this.freeZone = false,
    this.foreign = false,
  });

  final String id;
  final String name;
  final String documentType;
  final String documentNumber;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String? taxId;

  /// Cliente en zona franca: subtotal sin IVA; IVA en totales = 0.
  final bool freeZone;

  /// Cliente extranjero (factura tipo 02 en ERP).
  final bool foreign;

  String get documentLabel => '$documentType $documentNumber';

  Customer copyWith({
    String? id,
    String? name,
    String? documentType,
    String? documentNumber,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? taxId,
    bool? freeZone,
    bool? foreign,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      taxId: taxId ?? this.taxId,
      freeZone: freeZone ?? this.freeZone,
      foreign: foreign ?? this.foreign,
    );
  }
}
