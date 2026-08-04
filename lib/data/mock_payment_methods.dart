import 'package:flutter/material.dart';
import '../domain/models/payment_method.dart';

/// Datos mock extensibles para opciones de pago en checkout.
class PaymentMethodOption {
  const PaymentMethodOption({
    required this.method,
    required this.label,
    required this.description,
    required this.icon,
  });

  final PaymentMethod method;
  final String label;
  final String description;
  final IconData icon;
}

abstract final class MockPaymentMethods {
  static const List<PaymentMethodOption> options = [
    PaymentMethodOption(
      method: PaymentMethod.cash,
      label: 'Efectivo',
      description: 'Cobro en caja con cálculo de cambio',
      icon: Icons.payments_rounded,
    ),
    PaymentMethodOption(
      method: PaymentMethod.transfer,
      label: 'Transfer / QR',
      description: 'Pago por transferencia o código QR',
      icon: Icons.qr_code_2_rounded,
    ),
    PaymentMethodOption(
      method: PaymentMethod.mixed,
      label: 'Mixto',
      description: 'Combinar efectivo y transferencia',
      icon: Icons.swap_horiz_rounded,
    ),
  ];

  static PaymentMethodOption byMethod(PaymentMethod method) {
    return options.firstWhere((o) => o.method == method);
  }
}
