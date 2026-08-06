import 'product.dart';

/// Resultado del desglose de una línea (base + impuestos).
class LineTaxComputation {
  const LineTaxComputation({
    required this.baseSinIva,
    required this.precioConIva,
    required this.ivaAmount,
    required this.taxes,
  });

  /// Base imponible de la línea.
  final double baseSinIva;

  /// Neto de la línea (con impuestos empaquetados o sumados).
  final double precioConIva;

  final double ivaAmount;
  final List<TaxBreakdownLine> taxes;
}

/// Calcula impuestos de línea según:
/// - valorBase = precio × cantidad (descuento = 0 en la app)
/// - si iva_incluido: base = valorBase / (1 + Σ% / 100)
/// - si no: base = valorBase
/// - importe de cada impuesto = base × % / 100
/// - neto: valorBase (incluido) o valorBase + Σ importes (excluido)
///
/// Los de base `total_factura` se resuelven a nivel carrito.
abstract final class LineTaxCalculator {
  static LineTaxComputation compute({
    required double linePrice,
    required List<ProductTax> taxes,
    required bool ivaIncluido,
  }) {
    final valorBase = linePrice;

    final applicable = taxes
        .where(
          (t) =>
              t.percentage > 0 && t.base != TaxCalculationBase.totalFactura,
        )
        .toList();

    final sumPct =
        applicable.fold<double>(0, (sum, t) => sum + t.percentage);

    final base = (ivaIncluido && sumPct > 0)
        ? valorBase / (1 + sumPct / 100)
        : valorBase;

    final lines = <TaxBreakdownLine>[];
    var ivaAmount = 0.0;

    for (final tax in applicable) {
      final amount = base * (tax.percentage / 100);
      if (tax.isIva) ivaAmount += amount;

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
    final neto = ivaIncluido ? valorBase : valorBase + sumImportes;

    return LineTaxComputation(
      baseSinIva: base,
      precioConIva: neto,
      ivaAmount: ivaAmount,
      taxes: lines,
    );
  }
}
