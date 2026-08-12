import '../../../../domain/models/product.dart' as pos;
import '../models/products.models.dart';

/// Convierte un [Product] del API al modelo POS del carrito.
class PosProductMapper {
  PosProductMapper._();

  static pos.Product toPosProduct(
    Product product, {
    SellingPriceOption? priceOption,
  }) {
    final options = product.sellingPrices.options;
    final option =
        priceOption ??
        (options.isNotEmpty
            ? options.first
            : SellingPriceOption(
                key: 'default',
                label: 'General',
                price: product.sellingPrice,
              ));

    final useCustomPrice = priceOption != null && priceOption.key != 'default';

    return pos.Product(
      id: useCustomPrice
          ? '${product.id}_${option.key}'
          : product.id.toString(),
      baseId: product.id.toString(),
      name: useCustomPrice ? '${product.name} (${option.label})' : product.name,
      price: option.price,
      stock: product.quantity,
      taxes: product.taxes
          .map(
            (t) => pos.ProductTax(
              code: t.code,
              name: t.name,
              percentage: t.percentage,
              base: pos.TaxCalculationBaseX.fromJson(t.base, isIva: t.isIva),
            ),
          )
          .toList(),
    );
  }
}
