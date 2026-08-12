import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/pos_controller.dart';
import '../../features/catalogo_productos/catalogo_productos_page.dart';
import '../../features/seleccion_cliente/seleccion_cliente_page.dart';

/// Orquesta el flujo POS: Cliente → Catálogo.
class VentaPage extends StatelessWidget {
  const VentaPage({super.key, required this.onReviewPay});

  final VoidCallback onReviewPay;

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final customer = pos.activeCustomer;

    if (customer == null) {
      return SeleccionClientePage(
        onCustomerSelected: pos.selectCustomer,
      );
    }

    return CatalogoProductosPage(
      onReviewPay: onReviewPay,
      onChangeCustomer: () {
        pos.clearCustomer();
      },
    );
  }
}

/// Alias legacy — usar [VentaPage].
typedef PosSaleFlowPage = VentaPage;
