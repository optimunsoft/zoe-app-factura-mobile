import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import 'widgets/lista_items_carrito.dart';
import 'widgets/barra_pagar_venta.dart';
import '../resumen_venta/resumen_venta_page.dart';

/// Pantalla 1 — Carrito / revisión de la venta.
/// Lista de productos con +/− y eliminar; CTA "Pagar" → resumen → formas de pago.
class RevisarVentaPage extends StatelessWidget {
  const RevisarVentaPage({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  Future<void> _openCheckoutSummary(BuildContext context) async {
    final pos = context.read<PosController>();
    if (pos.itemCount == 0) return;

    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const ResumenVentaPage(),
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
      body: ListaItemsCarrito(
        items: pos.cart,
        onQuantityChanged: (item, qty) {
          pos.setQuantity(item.product, qty);
        },
        onRemove: (item) => pos.removeItem(item.product),
      ),
      bottomNavigationBar: BarraPagarVenta(
        total: pos.total,
        itemCount: pos.itemCount,
        onPay: pos.itemCount > 0 ? () => _openCheckoutSummary(context) : null,
      ),
    );
  }
}

/// Alias legacy — usar [RevisarVentaPage].
typedef CheckoutPage = RevisarVentaPage;
