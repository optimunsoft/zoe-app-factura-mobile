import 'line_tax_calculator.dart';
import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.reteFuenteId,
  });

  final Product product;
  final int quantity;

  /// ID de retención retefuente (código 06). `null` = sin retención.
  final int? reteFuenteId;

  double get lineTotal => product.price * quantity;

  /// Base imponible de la línea (para calcular retefuente).
  double withholdingBase({required bool ivaIncluido}) {
    return LineTaxCalculator.compute(
      linePrice: lineTotal,
      taxes: product.taxes,
      ivaIncluido: ivaIncluido,
    ).baseSinIva;
  }

  /// Impuestos de la línea (descuento = 0; ver [LineTaxCalculator]).
  List<TaxBreakdownLine> lineTaxes({required bool ivaIncluido}) {
    return LineTaxCalculator.compute(
      linePrice: lineTotal,
      taxes: product.taxes,
      ivaIncluido: ivaIncluido,
    ).taxes;
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    int? reteFuenteId,
    bool clearReteFuente = false,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      reteFuenteId:
          clearReteFuente ? null : (reteFuenteId ?? this.reteFuenteId),
    );
  }
}
