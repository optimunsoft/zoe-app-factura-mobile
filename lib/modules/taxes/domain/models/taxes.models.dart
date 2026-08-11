/// Códigos DIAN de retenciones.
abstract final class RetentionCodes {
  static const reteIva = '05';
  static const reteFuente = '06';
  static const reteIca = '07';
}

/// Query params de GET /retencion/getAll.
class TaxesQuery {
  TaxesQuery({
    this.page = '1',
    this.amount = '10',
  });

  final String page;
  final String amount;

  Map<String, dynamic> toQueryMap() {
    return {
      'page': page,
      'amount': amount,
    };
  }
}

/// Tipo de retención (catálogo).
class Retention {
  Retention({
    required this.id,
    required this.code,
    required this.name,
    required this.factor,
  });

  final int id;
  final String code;
  final String name;
  final int factor;

  factory Retention.fromJson(Map<String, dynamic> json) {
    return Retention(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      factor: (json['factor'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isReteIva => code == RetentionCodes.reteIva;
  bool get isReteFuente => code == RetentionCodes.reteFuente;
  bool get isReteIca => code == RetentionCodes.reteIca;
}

/// Retención configurada (porcentaje + descripción).
class TaxRetention {
  TaxRetention({
    required this.id,
    required this.description,
    required this.percentage,
    required this.retention,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String description;

  /// Porcentaje como string decimal (ej. `"8.600"`).
  final String percentage;
  final Retention retention;
  final String? createdAt;
  final String? updatedAt;

  factory TaxRetention.fromJson(Map<String, dynamic> json) {
    final retentionRaw = json['retention'];

    return TaxRetention(
      id: (json['id'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      percentage: json['percentage']?.toString() ?? '0',
      retention: retentionRaw is Map
          ? Retention.fromJson(Map<String, dynamic>.from(retentionRaw))
          : Retention(id: 0, code: '', name: '', factor: 0),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  double get percentageValue => double.tryParse(percentage) ?? 0;

  /// Importe = base × percentage / factor (factor por defecto 100).
  double amountOn(double base) {
    if (base <= 0 || percentageValue <= 0) return 0;
    final factor = retention.factor > 0 ? retention.factor : 100;
    return base * percentageValue / factor;
  }
}
