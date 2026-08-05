/// Método de pago oficial (catálogo DIAN / fiscal).
class OfficialPaymentMethod {
  OfficialPaymentMethod({
    required this.id,
    required this.name,
    required this.code,
  });

  final int id;
  final String name;
  final String code;

  factory OfficialPaymentMethod.fromJson(Map<String, dynamic> json) {
    return OfficialPaymentMethod(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

/// Medio de pago configurado en la empresa.
class MethodPayment {
  MethodPayment({
    required this.id,
    required this.name,
    required this.officialPaymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final OfficialPaymentMethod officialPaymentMethod;
  final String? createdAt;
  final String? updatedAt;

  factory MethodPayment.fromJson(Map<String, dynamic> json) {
    final officialRaw = json['oficial_payment_method'];

    return MethodPayment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      officialPaymentMethod: officialRaw is Map
          ? OfficialPaymentMethod.fromJson(
              Map<String, dynamic>.from(officialRaw),
            )
          : OfficialPaymentMethod(id: 0, name: '', code: ''),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  bool get isCash => name.toLowerCase().contains('efectivo');

  bool get isTransfer => name.toLowerCase().contains('transfer');
}
