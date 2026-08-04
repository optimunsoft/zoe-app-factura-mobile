import 'cart_item.dart';
import 'payment_method.dart';

enum InvoiceStatus { paid, voided }

extension InvoiceStatusX on InvoiceStatus {
  String get label => switch (this) {
        InvoiceStatus.paid => 'Pagada',
        InvoiceStatus.voided => 'Anulada',
      };
}

class SaleReceipt {
  const SaleReceipt({
    required this.orderId,
    required this.timestamp,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    this.cashReceived,
    this.changeDue,
  });

  final String orderId;
  final DateTime timestamp;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final PaymentMethod paymentMethod;
  final InvoiceStatus status;
  final double? cashReceived;
  final double? changeDue;
}

class DailyReport {
  const DailyReport({
    required this.totalSales,
    required this.invoiceCount,
    required this.taxCollected,
    required this.cashAmount,
    required this.digitalAmount,
  });

  final double totalSales;
  final int invoiceCount;
  final double taxCollected;
  final double cashAmount;
  final double digitalAmount;
}
