import 'line_tax_calculator.dart';
import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  /// Impuestos de la línea (descuento = 0; ver [LineTaxCalculator]).
  List<TaxBreakdownLine> lineTaxes({required bool ivaIncluido}) {
    return LineTaxCalculator.compute(
      linePrice: lineTotal,
      taxes: product.taxes,
      ivaIncluido: ivaIncluido,
    ).taxes;
  }

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
