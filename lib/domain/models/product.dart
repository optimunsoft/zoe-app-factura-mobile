/// Base de cálculo configurada para un impuesto / retención / cargo.
enum TaxCalculationBase {
  /// Valor del producto sin IVA.
  sinIva,

  /// Valor del producto con IVA.
  conIva,

  /// Solo el monto del IVA.
  valorIva,

  /// Precio de venta de la línea (tal cual en catálogo).
  precio,

  /// Total de la factura (se calcula a nivel carrito).
  totalFactura,
}

extension TaxCalculationBaseX on TaxCalculationBase {
  static TaxCalculationBase fromJson(dynamic raw, {required bool isIva}) {
    final value = raw?.toString().trim().toLowerCase() ?? '';

    switch (value) {
      case 'sin_iva':
      case 'siniva':
      case 'base':
      case 'subtotal':
      case 'neto':
        return TaxCalculationBase.sinIva;
      case 'con_iva':
      case 'coniva':
      case 'bruto':
        return TaxCalculationBase.conIva;
      case 'valor_iva':
      case 'iva':
      case 'monto_iva':
        return TaxCalculationBase.valorIva;
      case 'precio':
      case 'selling_price':
      case 'precio_venta':
        return TaxCalculationBase.precio;
      case 'total_factura':
      case 'total':
      case 'factura':
        return TaxCalculationBase.totalFactura;
      default:
        // Sin base explícita: IVA y demás usan valor sin IVA.
        return TaxCalculationBase.sinIva;
    }
  }
}

class ProductTax {
  const ProductTax({
    required this.code,
    required this.name,
    required this.percentage,
    this.base = TaxCalculationBase.sinIva,
  });

  final String code;
  final String name;
  final double percentage;
  final TaxCalculationBase base;

  /// Código DIAN 01 o nombre con "IVA".
  bool get isIva {
    final n = name.toUpperCase();
    return code == '01' || n.contains('IVA');
  }
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.taxes = const [],
  });

  final String id;
  final String name;
  final double price;
  final int stock;
  final List<ProductTax> taxes;

  bool get inStock => stock > 0;
  bool get lowStock => stock > 0 && stock <= 8;
}

/// Impuesto acumulado en el carrito (agrupado por código).
class TaxBreakdownLine {
  const TaxBreakdownLine({
    required this.code,
    required this.name,
    required this.percentage,
    required this.amount,
    this.includedInPrice = false,
    this.base = TaxCalculationBase.sinIva,
  });

  final String code;
  final String name;
  final double percentage;
  final double amount;

  /// true = ya va en el precio (p. ej. IVA desglosado con iva_incluido).
  final bool includedInPrice;
  final TaxCalculationBase base;

  String get label {
    final pct = percentage % 1 == 0
        ? percentage.toStringAsFixed(0)
        : percentage.toStringAsFixed(2);
    return '$name ($pct%)';
  }

  bool get isIva {
    final n = name.toUpperCase();
    return code == '01' || n.contains('IVA');
  }

  TaxBreakdownLine copyWith({double? amount}) {
    return TaxBreakdownLine(
      code: code,
      name: name,
      percentage: percentage,
      amount: amount ?? this.amount,
      includedInPrice: includedInPrice,
      base: base,
    );
  }
}
