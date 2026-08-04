import 'package:flutter/foundation.dart';
import '../domain/models/cart_item.dart';
import '../domain/models/customer.dart';
import '../domain/models/payment_method.dart';
import '../domain/models/product.dart';
import '../domain/models/sale_receipt.dart';
import 'mock_catalog.dart';

class PosController extends ChangeNotifier {
  final List<CartItem> _cart = [];
  Customer? activeCustomer;
  SaleReceipt? lastReceipt;
  bool printerConnected = true;
  String printerMode = 'Bluetooth';

  List<CartItem> get cart => List.unmodifiable(_cart);

  bool get hasCustomer => activeCustomer != null;

  int get itemCount => _cart.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _cart.fold(0.0, (sum, i) => sum + i.lineTotal);

  double get tax => subtotal * MockCatalog.taxRate;

  double get discount => 0;

  double get total => subtotal + tax - discount;

  void selectCustomer(Customer customer) {
    activeCustomer = customer;
    notifyListeners();
  }

  void clearCustomer() {
    activeCustomer = null;
    notifyListeners();
  }

  /// Reinicia el flujo de venta (cliente + carrito).
  void startNewSale() {
    activeCustomer = null;
    _cart.clear();
    notifyListeners();
  }

  int quantityOf(String productId) {
    final match = _cart.where((i) => i.product.id == productId);
    return match.isEmpty ? 0 : match.first.quantity;
  }

  void addProduct(Product product) {
    if (!product.inStock) return;
    final index = _cart.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      final current = _cart[index];
      if (current.quantity >= product.stock) return;
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
    final capped = qty > product.stock ? product.stock : qty;
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
    final receipt = SaleReceipt(
      orderId: id,
      timestamp: now,
      items: List.from(_cart),
      subtotal: subtotal,
      tax: tax,
      discount: discountAmount,
      total: subtotal + tax - discountAmount,
      paymentMethod: method,
      status: InvoiceStatus.paid,
      cashReceived: cashReceived,
      changeDue: cashReceived != null
          ? cashReceived - (subtotal + tax - discountAmount)
          : null,
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
