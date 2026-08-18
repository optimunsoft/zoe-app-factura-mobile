import '../../../../core/api_helpers.dart';

/// Query params de GET /ventas/reportes/ingresos-medios-pago (todos requeridos).
class IngresosMediosPagoQuery {
  IngresosMediosPagoQuery({
    required this.startDate,
    required this.endDate,
    required this.branchId,
  });

  /// `fecha_inicio` — YYYY-MM-DD.
  final String startDate;

  /// `fecha_fin` — YYYY-MM-DD.
  final String endDate;

  /// `id_sucursal`.
  final String branchId;

  Map<String, dynamic> toQueryMap() {
    return <String, dynamic>{
      'id_sucursal': branchId,
      'fecha_inicio': startDate,
      'fecha_fin': endDate,
    };
  }
}

/// Línea de medio de pago dentro de `detalle_pago` (cuando viene como lista).
class IngresoMedioPagoLinea {
  const IngresoMedioPagoLinea({
    required this.amount,
    required this.name,
    required this.paymentMethodId,
  });

  /// `valor`.
  final double amount;

  /// `nombre` — ej. `"Efectivo"`, `"Transferencia"`.
  final String name;

  /// `id_medio_pago`.
  final int paymentMethodId;

  factory IngresoMedioPagoLinea.fromJson(Map<String, dynamic> json) {
    return IngresoMedioPagoLinea(
      amount: asDouble(json['valor']) ?? 0,
      name: json['nombre']?.toString() ?? '',
      paymentMethodId: asInt(json['id_medio_pago']) ?? 0,
    );
  }
}

/// Ítem de GET /ventas/reportes/ingresos-medios-pago.
///
/// `detalle_pago` puede venir como lista de medios o como objeto
/// `{ fecha, forma, metodo }` (sin desglose). En el segundo caso
/// [paymentDetails] queda vacío.
class IngresoMedioPagoItem {
  const IngresoMedioPagoItem({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.thirdPartyId,
    required this.documentNumber,
    required this.thirdPartyNit,
    required this.thirdPartyName,
    required this.saleDate,
    required this.paymentForm,
    required this.paymentDetails,
    required this.invoiceTotal,
    required this.amountDue,
  });

  final int id;
  final int branchId;
  final String branchName;
  final int thirdPartyId;
  final String documentNumber;
  final String thirdPartyNit;
  final String thirdPartyName;
  final String saleDate;
  final String paymentForm;
  final List<IngresoMedioPagoLinea> paymentDetails;

  /// `total_factura` como string decimal (ej. `"0.00"`).
  final String invoiceTotal;

  /// `total_a_pagar` como string decimal (ej. `"0.00"`).
  final String amountDue;

  factory IngresoMedioPagoItem.fromJson(Map<String, dynamic> json) {
    return IngresoMedioPagoItem(
      id: asInt(json['id']) ?? 0,
      branchId: asInt(json['id_sucursal']) ?? 0,
      branchName: json['nombre_sucursal']?.toString() ?? '',
      thirdPartyId: asInt(json['id_tercero']) ?? 0,
      documentNumber: json['nro_documento']?.toString() ?? '',
      thirdPartyNit: json['nit_tercero']?.toString() ?? '',
      thirdPartyName: json['nombre_tercero']?.toString() ?? '',
      saleDate: json['fecha_venta']?.toString() ?? '',
      paymentForm: json['forma_pago']?.toString() ?? '',
      paymentDetails: _parsePaymentDetails(json['detalle_pago']),
      invoiceTotal: json['total_factura']?.toString() ?? '0.00',
      amountDue: json['total_a_pagar']?.toString() ?? '0.00',
    );
  }

  double get invoiceTotalValue => asDouble(invoiceTotal) ?? 0;
  double get amountDueValue => asDouble(amountDue) ?? 0;

  static List<IngresoMedioPagoLinea> _parsePaymentDetails(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map(
            (e) => IngresoMedioPagoLinea.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      if (map.containsKey('id_medio_pago') || map.containsKey('valor')) {
        return [IngresoMedioPagoLinea.fromJson(map)];
      }
    }

    return const [];
  }

  static List<IngresoMedioPagoItem> listFromResponse(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map(
            (e) => IngresoMedioPagoItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final nested = map['data'] ?? map['items'] ?? map['response'];
      if (nested is List) return listFromResponse(nested);
    }

    return const [];
  }
}
