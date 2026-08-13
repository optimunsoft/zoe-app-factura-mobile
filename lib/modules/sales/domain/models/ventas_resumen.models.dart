import '../../../../core/api_helpers.dart';

/// Query params de GET /ventas/resumen (todos requeridos).
class VentasResumenQuery {
  VentasResumenQuery({
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
      'fecha_inicio': startDate,
      'fecha_fin': endDate,
      'id_sucursal': branchId,
    };
  }

  /// Año calendario actual + sucursal de sesión.
  factory VentasResumenQuery.currentYear({required String branchId}) {
    final year = DateTime.now().year;
    final yyyy = year.toString().padLeft(4, '0');
    return VentasResumenQuery(
      startDate: '$yyyy-01-01',
      endDate: '$yyyy-12-31',
      branchId: branchId,
    );
  }
}

/// Bloque `totalizado` de GET /ventas/resumen.
class VentasResumenTotalizado {
  const VentasResumenTotalizado({
    required this.totalProductos,
    required this.totalDescuento,
    required this.subtotal,
    required this.totalImpuestos,
    required this.totalFactura,
    required this.totalRetenciones,
    required this.totalAPagar,
  });

  final double totalProductos;
  final double totalDescuento;
  final double subtotal;
  final double totalImpuestos;
  final double totalFactura;
  final double totalRetenciones;
  final double totalAPagar;

  factory VentasResumenTotalizado.fromJson(Map<String, dynamic> json) {
    return VentasResumenTotalizado(
      totalProductos: asDouble(json['total_productos']) ?? 0,
      totalDescuento: asDouble(json['total_descuento']) ?? 0,
      subtotal: asDouble(json['subtotal']) ?? 0,
      totalImpuestos: asDouble(json['total_impuestos']) ?? 0,
      totalFactura: asDouble(json['total_factura']) ?? 0,
      totalRetenciones: asDouble(json['total_retenciones']) ?? 0,
      totalAPagar: asDouble(json['total_a_pagar']) ?? 0,
    );
  }

  static const empty = VentasResumenTotalizado(
    totalProductos: 0,
    totalDescuento: 0,
    subtotal: 0,
    totalImpuestos: 0,
    totalFactura: 0,
    totalRetenciones: 0,
    totalAPagar: 0,
  );
}

/// Respuesta tipada de GET /ventas/resumen (`data.response`).
class VentasResumen {
  const VentasResumen({
    required this.facturado,
    required this.carteraGenerada,
    required this.cantidadFacturas,
    required this.porcentajeCartera,
    required this.totalizado,
  });

  final double facturado;
  final double carteraGenerada;
  final int cantidadFacturas;
  final double porcentajeCartera;
  final VentasResumenTotalizado totalizado;

  factory VentasResumen.fromJson(Map<String, dynamic> json) {
    final totalizadoRaw = json['totalizado'];
    return VentasResumen(
      facturado: asDouble(json['facturado']) ?? 0,
      carteraGenerada: asDouble(json['cartera_generada']) ?? 0,
      cantidadFacturas: asInt(json['cantidad_facturas']) ?? 0,
      porcentajeCartera: asDouble(json['porcentaje_cartera']) ?? 0,
      totalizado: totalizadoRaw is Map
          ? VentasResumenTotalizado.fromJson(
              Map<String, dynamic>.from(totalizadoRaw),
            )
          : VentasResumenTotalizado.empty,
    );
  }

  static const empty = VentasResumen(
    facturado: 0,
    carteraGenerada: 0,
    cantidadFacturas: 0,
    porcentajeCartera: 0,
    totalizado: VentasResumenTotalizado.empty,
  );
}
