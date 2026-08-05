import 'product.dart';

/// Resultado del desglose de una línea (base + IVA + impuestos).
class LineTaxComputation {
  const LineTaxComputation({
    required this.baseSinIva,
    required this.precioConIva,
    required this.ivaAmount,
    required this.taxes,
  });

  final double baseSinIva;
  final double precioConIva;
  final double ivaAmount;
  final List<TaxBreakdownLine> taxes;
}

/// Calcula impuestos de línea respetando `iva_incluido` y la base de cada tax.
///
/// Ejemplo con `iva_incluido = true`, precio $15.000 e IVA 19 %:
/// - Base sin IVA = 15.000 / 1.19 = $12.605,04
/// - IVA desglosado = $2.394,96
/// - Impuesto adicional 8 % = 12.605,04 × 0.08 = $1.008,40
abstract final class LineTaxCalculator {
  static LineTaxComputation compute({
    required double linePrice,
    required List<ProductTax> taxes,
    required bool ivaIncluido,
  }) {
    final applicable = taxes.where((t) => t.percentage > 0).toList();
    final ivaTax = _findIva(applicable);

    final split = _splitPriceAndIva(
      linePrice: linePrice,
      ivaTax: ivaTax,
      ivaIncluido: ivaIncluido,
    );

    final lines = <TaxBreakdownLine>[];

    for (final tax in applicable) {
      // total_factura se resuelve a nivel carrito.
      if (tax.base == TaxCalculationBase.totalFactura) continue;

      final amount = _amountFor(
        tax,
        ivaIncluido: ivaIncluido,
        baseSinIva: split.baseSinIva,
        precioConIva: split.precioConIva,
        ivaAmount: split.ivaAmount,
      );

      lines.add(
        TaxBreakdownLine(
          code: tax.code,
          name: tax.name,
          percentage: tax.percentage,
          amount: amount,
          includedInPrice: ivaIncluido && tax.isIva,
          base: tax.base,
        ),
      );
    }

    return LineTaxComputation(
      baseSinIva: split.baseSinIva,
      precioConIva: split.precioConIva,
      ivaAmount: split.ivaAmount,
      taxes: lines,
    );
  }

  static ProductTax? _findIva(List<ProductTax> taxes) {
    for (final t in taxes) {
      if (t.isIva) return t;
    }
    return null;
  }

  /// Separa (o construye) base sin IVA e IVA según [ivaIncluido].
  static ({double baseSinIva, double ivaAmount, double precioConIva})
      _splitPriceAndIva({
    required double linePrice,
    required ProductTax? ivaTax,
    required bool ivaIncluido,
  }) {
    if (ivaTax == null) {
      return (
        baseSinIva: linePrice,
        ivaAmount: 0,
        precioConIva: linePrice,
      );
    }

    final rate = ivaTax.percentage;

    if (ivaIncluido) {
      // Precio trae IVA: base = precio / (1 + %).
      // Ej. 15000 / 1.19 = 12605.042016...
      final baseSinIva = linePrice * (100 / (100 + rate));
      final ivaAmount = linePrice - baseSinIva;
      return (
        baseSinIva: baseSinIva,
        ivaAmount: ivaAmount,
        precioConIva: linePrice,
      );
    }

    // Precio es base sin IVA: IVA = base × %.
    final baseSinIva = linePrice;
    final ivaAmount = baseSinIva * (rate / 100);
    return (
      baseSinIva: baseSinIva,
      ivaAmount: ivaAmount,
      precioConIva: baseSinIva + ivaAmount,
    );
  }

  static double _amountFor(
    ProductTax tax, {
    required bool ivaIncluido,
    required double baseSinIva,
    required double precioConIva,
    required double ivaAmount,
  }) {
    // IVA incluido: solo desglose (no se vuelve a calcular sobre otra base).
    if (tax.isIva && ivaIncluido) {
      return ivaAmount;
    }

    // IVA no incluido: sobre la base sin IVA.
    if (tax.isIva) {
      return baseSinIva * (tax.percentage / 100);
    }

    // Impuestos / cargos adicionales según su base configurada.
    // Los que aplican sobre el valor del producto usan SIEMPRE la base sin IVA
    // (tras separar el IVA si venía incluido).
    final base = _taxableBaseFor(
      tax.base,
      baseSinIva: baseSinIva,
      precioConIva: precioConIva,
      ivaAmount: ivaAmount,
    );
    return base * (tax.percentage / 100);
  }

  /// Resuelve la base gravable del impuesto adicional.
  ///
  /// - `sin_iva` / `precio` / default → valor del producto sin IVA
  /// - `con_iva` → valor con IVA
  /// - `valor_iva` → monto del IVA
  static double _taxableBaseFor(
    TaxCalculationBase base, {
    required double baseSinIva,
    required double precioConIva,
    required double ivaAmount,
  }) {
    return switch (base) {
      // Valor del producto: siempre la base gravable sin IVA.
      TaxCalculationBase.sinIva => baseSinIva,
      TaxCalculationBase.precio => baseSinIva,
      TaxCalculationBase.conIva => precioConIva,
      TaxCalculationBase.valorIva => ivaAmount,
      TaxCalculationBase.totalFactura => baseSinIva,
    };
  }
}
