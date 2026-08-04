import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/pos_controller.dart';
import '../organisms/cart_items_list.dart';
import '../organisms/checkout_pay_bar.dart';
import 'payment_methods_page.dart';

/// Pantalla 1 — Carrito / Checkout inicial.
/// Lista de productos con +/− y eliminar; CTA "Pagar" → formas de pago.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  Future<void> _openPaymentMethods(BuildContext context) async {
    final pos = context.read<PosController>();
    if (pos.itemCount == 0) return;

    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const PaymentMethodsPage(),
      ),
    );

    if (completed == true && context.mounted) {
      onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito', style: AppTextStyles.h2),
      ),
      body: CartItemsList(
        items: pos.cart,
        onQuantityChanged: (item, qty) {
          pos.setQuantity(item.product, qty);
        },
        onRemove: (item) => pos.removeItem(item.product),
      ),
      bottomNavigationBar: CheckoutPayBar(
        total: pos.total,
        itemCount: pos.itemCount,
        onPay: pos.itemCount > 0 ? () => _openPaymentMethods(context) : null,
      ),
    );
  }
}
