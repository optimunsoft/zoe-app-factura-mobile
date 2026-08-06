import 'package:flutter/foundation.dart';
import '../domain/models/cart_item.dart';
import '../domain/models/customer.dart';
import '../domain/models/payment_method.dart';
import '../domain/models/product.dart';
import '../domain/models/sale_receipt.dart';

class PosController extends ChangeNotifier {
  final List<CartItem> _cart = [];
  Customer? activeCustomer;
  SaleReceipt? lastReceipt;
  bool printerConnected = true;
  String printerMode = 'Bluetooth';

  /// Viene del login (`iva_incluido`).
  bool ivaIncluido = false;

  List<CartItem> get cart => List.unmodifiable(_cart);

  bool get hasCustomer => activeCustomer != null;

  int get itemCount => _cart.fold(0, (sum, i) => sum + i.quantity);

  /// Suma de precios de venta × cantidad (tal cual en catálogo).
  double get goodsTotal => _cart.fold(0.0, (sum, i) => sum + i.lineTotal);

  /// Impuestos de línea + los de base `total_factura`.
  List<TaxBreakdownLine> get taxBreakdown {
    final map = <String, TaxBreakdownLine>{};

    for (final item in _cart) {
      for (final lineTax in item.lineTaxes(ivaIncluido: ivaIncluido)) {
        _mergeTax(map, lineTax);
      }
    }

    // Segunda pasada: bases sobre el total de factura.
    final provisionalTotal = _provisionalTotal(map);
    for (final item in _cart) {
      for (final tax in item.product.taxes) {
        if (tax.percentage <= 0) continue;
        if (tax.base != TaxCalculationBase.totalFactura) continue;

        _mergeTax(
          map,
          TaxBreakdownLine(
            code: tax.code,
            name: tax.name,
            percentage: tax.percentage,
            amount: provisionalTotal * (tax.percentage / 100),
            includedInPrice: false,
            base: tax.base,
          ),
        );
      }
    }

    return map.values.toList();
  }

  void _mergeTax(Map<String, TaxBreakdownLine> map, TaxBreakdownLine line) {
    final existing = map[line.code];
    if (existing == null) {
      map[line.code] = line;
    } else {
      map[line.code] = existing.copyWith(
        amount: existing.amount + line.amount,
      );
    }
  }

  /// Total provisional (precios + cargos de línea no incluidos en el precio).
  double _provisionalTotal(Map<String, TaxBreakdownLine> lineTaxes) {
    final additional = lineTaxes.values
        .where((t) => !t.includedInPrice)
        .fold(0.0, (sum, t) => sum + t.amount);
    return goodsTotal + additional;
  }

  double get tax => taxBreakdown.fold(0.0, (sum, t) => sum + t.amount);

  double get _includedTaxAmount => taxBreakdown
      .where((t) => t.includedInPrice)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _additionalTaxAmount => taxBreakdown
      .where((t) => !t.includedInPrice)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// Base imponible mostrada en resumen.
  double get subtotal {
    if (ivaIncluido) {
      return goodsTotal - _includedTaxAmount;
    }
    return goodsTotal;
  }

  double get discount => 0;

  /// Total a cobrar = precios + impuestos/cargos que no vienen incluidos.
  double get total => goodsTotal + _additionalTaxAmount - discount;

  void setIvaIncluido(bool value) {
    ivaIncluido = value;
    notifyListeners();
  }

  void selectCustomer(Customer customer) {
    activeCustomer = customer;
    notifyListeners();
  }

  void clearCustomer() {
    activeCustomer = null;
    notifyListeners();
  }

  void startNewSale() {
    activeCustomer = null;
    _cart.clear();
    notifyListeners();
  }

  int quantityOf(String productId) {
    final match = _cart.where((i) => i.product.id == productId);
    return match.isEmpty ? 0 : match.first.quantity;
  }

  /// Cantidad total en carrito del mismo producto (todas las variantes de precio).
  int quantityOfBase(String stockKey) {
    return _cart
        .where((i) => i.product.stockKey == stockKey)
        .fold(0, (sum, i) => sum + i.quantity);
  }

  /// Máximo permitido para esta línea respetando el stock compartido.
  int maxQuantityFor(Product product) {
    final others =
        quantityOfBase(product.stockKey) - quantityOf(product.id);
    final max = product.stock - others;
    return max < 0 ? 0 : max;
  }

  void addProduct(Product product) {
    if (!product.inStock) return;
    if (quantityOfBase(product.stockKey) >= product.stock) return;

    final index = _cart.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      final current = _cart[index];
      _cart[index] = current.copyWith(quantity: current.quantity + 1);
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void setQuantity(Product product, int qty) {
    final index = _cart.indexWhere((i) => i.product.id == product.id);
    if (qty <= 0) {
      if (index >= 0) {
        _cart.removeAt(index);
        notifyListeners();
      }
      return;
    }

    final maxForLine = maxQuantityFor(product);
    final capped = qty > maxForLine ? maxForLine : qty;
    if (capped <= 0) {
      if (index >= 0) {
        _cart.removeAt(index);
        notifyListeners();
      }
      return;
    }

    if (index >= 0) {
      _cart[index] = _cart[index].copyWith(quantity: capped);
    } else {
      _cart.add(CartItem(product: product, quantity: capped));
    }
    notifyListeners();
  }

  void increment(Product product) => addProduct(product);

  void decrement(Product product) {
    final qty = quantityOf(product.id);
    if (qty <= 0) return;
    setQuantity(product, qty - 1);
  }

  void removeItem(Product product) => setQuantity(product, 0);

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  SaleReceipt completeSale({
    required PaymentMethod method,
    double? cashReceived,
    double discountAmount = 0,
  }) {
    final now = DateTime.now();
    final id =
        'INV-${1000 + now.millisecond + now.second + (_cart.length * 7)}';
    final saleTotal = goodsTotal + _additionalTaxAmount - discountAmount;
    final receipt = SaleReceipt(
      orderId: id,
      timestamp: now,
      items: List.from(_cart),
      subtotal: subtotal,
      tax: tax,
      taxBreakdown: List.from(taxBreakdown),
      discount: discountAmount,
      total: saleTotal,
      paymentMethod: method,
      status: InvoiceStatus.paid,
      cashReceived: cashReceived,
      changeDue:
          cashReceived != null ? cashReceived - saleTotal : null,
    );
    lastReceipt = receipt;
    _cart.clear();
    activeCustomer = null;
    notifyListeners();
    return receipt;
  }

  void togglePrinter() {
    printerConnected = !printerConnected;
    notifyListeners();
  }
}
