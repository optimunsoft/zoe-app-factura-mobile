import '../domain/models/product.dart';
import '../domain/models/sale_receipt.dart';
import '../domain/models/cart_item.dart';
import '../domain/models/payment_method.dart';

abstract final class MockCatalog {
  static const taxRate = 0.16;

  static final List<Product> products = [
    const Product(
      id: 'p01',
      name: 'Coca-Cola 600ml',
      price: 18.50,
      stock: 42,
      category: ProductCategory.drinks,
      emoji: '🥤',
    ),
    const Product(
      id: 'p02',
      name: 'Agua Ciel 1L',
      price: 12.00,
      stock: 60,
      category: ProductCategory.drinks,
      emoji: '💧',
    ),
    const Product(
      id: 'p03',
      name: 'Gatorade 500ml',
      price: 22.00,
      stock: 18,
      category: ProductCategory.drinks,
      emoji: '🧃',
    ),
    const Product(
      id: 'p04',
      name: 'Sabritas Original',
      price: 18.00,
      stock: 35,
      category: ProductCategory.snacks,
      emoji: '🥔',
    ),
    const Product(
      id: 'p05',
      name: 'Doritos Nacho',
      price: 19.50,
      stock: 5,
      category: ProductCategory.snacks,
      emoji: '🌮',
    ),
    const Product(
      id: 'p06',
      name: 'Galletas Emperador',
      price: 16.00,
      stock: 24,
      category: ProductCategory.snacks,
      emoji: '🍪',
    ),
    const Product(
      id: 'p07',
      name: 'Leche Lala 1L',
      price: 28.90,
      stock: 20,
      category: ProductCategory.dairy,
      emoji: '🥛',
    ),
    const Product(
      id: 'p08',
      name: 'Yogurt Danone',
      price: 14.50,
      stock: 3,
      category: ProductCategory.dairy,
      emoji: '🫙',
    ),
    const Product(
      id: 'p09',
      name: 'Queso Panela 400g',
      price: 62.00,
      stock: 12,
      category: ProductCategory.dairy,
      emoji: '🧀',
    ),
    const Product(
      id: 'p10',
      name: 'Aceite Capullo 1L',
      price: 48.00,
      stock: 15,
      category: ProductCategory.grocery,
      emoji: '🫒',
    ),
    const Product(
      id: 'p11',
      name: 'Arroz Verde Valle 1kg',
      price: 32.00,
      stock: 0,
      category: ProductCategory.grocery,
      emoji: '🍚',
    ),
    const Product(
      id: 'p12',
      name: 'Frijol Negro 1kg',
      price: 36.50,
      stock: 22,
      category: ProductCategory.grocery,
      emoji: '🫘',
    ),
  ];

  static final List<SaleReceipt> recentSales = [
    SaleReceipt(
      orderId: 'INV-1048',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      items: [
        CartItem(product: products[0], quantity: 4),
        CartItem(product: products[3], quantity: 2),
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
        CartItem(product: products[6], quantity: 3),
        CartItem(product: products[9], quantity: 1),
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
        CartItem(product: products[4], quantity: 6),
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
        CartItem(product: products[1], quantity: 10),
        CartItem(product: products[2], quantity: 2),
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
