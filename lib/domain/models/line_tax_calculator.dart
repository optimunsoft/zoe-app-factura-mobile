import 'product.dart';

/// Resultado del desglose de una línea (DIAN / Emitir documentos).
class LineTaxComputation {
  const LineTaxComputation({
    required this.precioConDescuento,
    required this.valorBase,
    required this.valueDiscount,
    required this.baseImponible,
    required this.valorNeto,
    required this.valorNetoSinIva,
    required this.ivaAmount,
    required this.taxes,
  });

  final double precioConDescuento;
  final double valorBase;
  final double valueDiscount;

  /// Base imponible de la línea.
  final double baseImponible;

  /// Neto de la línea (con impuestos empaquetados o sumados).
  final double valorNeto;

  /// Neto sin IVA (zona franca / desglose).
  final double valorNetoSinIva;

  final double ivaAmount;
  final List<TaxBreakdownLine> taxes;

  /// Alias legacy.
  double get baseSinIva => baseImponible;

  /// Alias legacy.
  double get precioConIva => valorNeto;
}

/// Calcula impuestos de línea según facturación colombiana (DIAN):
///
/// ```
/// precioConDescuento = precio − (precio × descuento% / 100)
/// valorBase          = precioConDescuento × cantidad
/// valueDiscount      = (precio × descuento% / 100) × cantidad
///
/// si iva_incluido: base = valorBase / (1 + Σ% / 100)
/// si no:           base = valorBase
///
/// importe = base × % / 100
/// si iva_incluido: valorNeto = precioConDescuento × cantidad
/// si no:           valorNeto = precioConDescuento × cantidad + Σ importe
///
/// valorNetoSinIVA:
///   si iva_incluido: precio×cant − IVA
///   si no:           precio×cant + impuestos que no son IVA (tipo ≠ "01")
/// ```
///
/// En la app el descuento de línea suele ser 0. Los de base `total_factura`
/// se resuelven a nivel carrito.
abstract final class LineTaxCalculator {
  static LineTaxComputation compute({
    required double unitPrice,
    required int quantity,
    required List<ProductTax> taxes,
    required bool ivaIncluido,
    double discountPercent = 0,
  }) {
    final qty = quantity < 0 ? 0 : quantity;
    final pct = discountPercent < 0 ? 0.0 : discountPercent;

    final discountPerUnit = unitPrice * pct / 100;
    final precioConDescuento = unitPrice - discountPerUnit;
    final valorBase = precioConDescuento * qty;
    final valueDiscount = discountPerUnit * qty;
    // Bruto sin descuento (para valorNetoSinIVA según fórmulas del ERP).
    final brutoSinDescuento = unitPrice * qty;

    final applicable = taxes
        .where(
          (t) =>
              t.percentage > 0 && t.base != TaxCalculationBase.totalFactura,
        )
        .toList();

    final sumPct =
        applicable.fold<double>(0, (sum, t) => sum + t.percentage);

    final baseImponible = (ivaIncluido && sumPct > 0)
        ? valorBase / (1 + sumPct / 100)
        : valorBase;

    final lines = <TaxBreakdownLine>[];
    var ivaAmount = 0.0;
    var nonIvaAmount = 0.0;

    for (final tax in applicable) {
      final amount = baseImponible * (tax.percentage / 100);
      if (tax.isIva) {
        ivaAmount += amount;
      } else {
        nonIvaAmount += amount;
      }

      lines.add(
        TaxBreakdownLine(
          code: tax.code,
          name: tax.name,
          percentage: tax.percentage,
          amount: amount,
          // Con IVA incluido el precio ya trae todos los impuestos de línea.
          includedInPrice: ivaIncluido,
          base: tax.base,
        ),
      );
    }

    final sumImportes = lines.fold<double>(0, (sum, t) => sum + t.amount);
    final valorNeto =
        ivaIncluido ? valorBase : valorBase + sumImportes;

    // Zona franca / neto sin IVA (fórmulas ProductPopup).
    final valorNetoSinIva = ivaIncluido
        ? brutoSinDescuento - ivaAmount
        : brutoSinDescuento + nonIvaAmount;

    return LineTaxComputation(
      precioConDescuento: precioConDescuento,
      valorBase: valorBase,
      valueDiscount: valueDiscount,
      baseImponible: baseImponible,
      valorNeto: valorNeto,
      valorNetoSinIva: valorNetoSinIva,
      ivaAmount: ivaAmount,
      taxes: lines,
    );
  }

  /// Compatibilidad con llamadas que pasan el total de línea ya calculado.
  static LineTaxComputation computeFromLinePrice({
    required double linePrice,
    required List<ProductTax> taxes,
    required bool ivaIncluido,
    double discountPercent = 0,
  }) {
    return compute(
      unitPrice: linePrice,
      quantity: 1,
      taxes: taxes,
      ivaIncluido: ivaIncluido,
      discountPercent: discountPercent,
    );
  }
}
