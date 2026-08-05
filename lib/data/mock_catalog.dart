import '../domain/models/product.dart';
import '../domain/models/sale_receipt.dart';
import '../domain/models/cart_item.dart';
import '../domain/models/payment_method.dart';

abstract final class MockCatalog {
  static const taxRate = 0.16;

  static final List<SaleReceipt> recentSales = [
    SaleReceipt(
      orderId: 'INV-1048',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      items: [
        CartItem(
          product: const Product(
            id: 'p01',
            name: 'Coca-Cola 600ml',
            price: 18.50,
            stock: 42,
          ),
          quantity: 4,
        ),
        CartItem(
          product: const Product(
            id: 'p04',
            name: 'Sabritas Original',
            price: 18.00,
            stock: 35,
          ),
          quantity: 2,
        ),
      ],
      subtotal: 110.00,
      tax: 17.60,
      discount: 0,
      total: 127.60,
      paymentMethod: PaymentMethod.cash,
      status: InvoiceStatus.paid,
      cashReceived: 150,
      changeDue: 22.40,
    ),
    SaleReceipt(
      orderId: 'INV-1047',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 5)),
      items: [
        CartItem(
          product: const Product(
            id: 'p07',
            name: 'Leche Lala 1L',
            price: 28.90,
            stock: 20,
          ),
          quantity: 3,
        ),
        CartItem(
          product: const Product(
            id: 'p10',
            name: 'Aceite Capullo 1L',
            price: 48.00,
            stock: 15,
          ),
          quantity: 1,
        ),
      ],
      subtotal: 134.70,
      tax: 21.55,
      discount: 5.00,
      total: 151.25,
      paymentMethod: PaymentMethod.transfer,
      status: InvoiceStatus.paid,
    ),
    SaleReceipt(
      orderId: 'INV-1046',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
      items: [
        CartItem(
          product: const Product(
            id: 'p05',
            name: 'Doritos Nacho',
            price: 19.50,
            stock: 5,
          ),
          quantity: 6,
        ),
      ],
      subtotal: 117.00,
      tax: 18.72,
      discount: 0,
      total: 135.72,
      paymentMethod: PaymentMethod.mixed,
      status: InvoiceStatus.voided,
    ),
    SaleReceipt(
      orderId: 'INV-1045',
      timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 12)),
      items: [
        CartItem(
          product: const Product(
            id: 'p02',
            name: 'Agua Ciel 1L',
            price: 12.00,
            stock: 60,
          ),
          quantity: 10,
        ),
        CartItem(
          product: const Product(
            id: 'p03',
            name: 'Gatorade 500ml',
            price: 22.00,
            stock: 18,
          ),
          quantity: 2,
        ),
      ],
      subtotal: 164.00,
      tax: 26.24,
      discount: 0,
      total: 190.24,
      paymentMethod: PaymentMethod.cash,
      status: InvoiceStatus.paid,
      cashReceived: 200,
      changeDue: 9.76,
    ),
  ];

  static DailyReport get todayReport => const DailyReport(
        totalSales: 4842.50,
        invoiceCount: 37,
        taxCollected: 668.48,
        cashAmount: 2910.00,
        digitalAmount: 1932.50,
      );
}
