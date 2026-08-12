import 'line_tax_calculator.dart';
import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.reteFuenteId,
    this.discountPercent = 0,
  });

  final Product product;
  final int quantity;

  /// ID de retención retefuente (código 06). `null` = sin retención.
  final int? reteFuenteId;

  /// Descuento % de línea (0 en POS actual; alineado a Emitir documentos).
  final double discountPercent;

  double get lineTotal => product.price * quantity;

  LineTaxComputation lineComputation({required bool ivaIncluido}) {
    return LineTaxCalculator.compute(
      unitPrice: product.price,
      quantity: quantity,
      taxes: product.taxes,
      ivaIncluido: ivaIncluido,
      discountPercent: discountPercent,
    );
  }

  /// Base imponible de la línea (para calcular retefuente).
  double withholdingBase({required bool ivaIncluido}) {
    return lineComputation(ivaIncluido: ivaIncluido).baseImponible;
  }

  /// Impuestos de la línea (ver [LineTaxCalculator]).
  List<TaxBreakdownLine> lineTaxes({required bool ivaIncluido}) {
    return lineComputation(ivaIncluido: ivaIncluido).taxes;
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    int? reteFuenteId,
    double? discountPercent,
    bool clearReteFuente = false,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      reteFuenteId:
          clearReteFuente ? null : (reteFuenteId ?? this.reteFuenteId),
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}
