import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/pos_controller.dart';
import '../../domain/models/payment_method.dart';
import '../organisms/payment_methods_panel.dart';
import '../organisms/payment_summary_footer.dart';

/// Pantalla 2 — Formas de pago.
/// Selección de método + resumen final y completar venta.
class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  PaymentMethod _method = PaymentMethod.cash;
  final _cashCtrl = TextEditingController();
  double _cashReceived = 0;

  @override
  void dispose() {
    _cashCtrl.dispose();
    super.dispose();
  }

  bool _requiresCash(PaymentMethod method) =>
      method == PaymentMethod.cash || method == PaymentMethod.mixed;

  void _completeSale(PosController pos) {
    if (pos.itemCount == 0) return;

    if (_requiresCash(_method) && _cashReceived < pos.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El efectivo recibido es insuficiente')),
      );
      return;
    }

    pos.completeSale(
      method: _method,
      cashReceived: _method == PaymentMethod.transfer ? null : _cashReceived,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Formas de pago', style: AppTextStyles.h2),
      ),
      body: PaymentMethodsPanel(
        selected: _method,
        onChanged: (m) => setState(() => _method = m),
        total: pos.total,
        cashController: _cashCtrl,
        cashReceived: _cashReceived,
        onCashChanged: (v) {
          setState(() {
            _cashReceived = double.tryParse(v.replaceAll(',', '')) ?? 0;
          });
        },
      ),
      bottomNavigationBar: PaymentSummaryFooter(
        subtotal: pos.subtotal,
        tax: pos.tax,
        discount: pos.discount,
        total: pos.total,
        canComplete: pos.itemCount > 0,
        onComplete: () => _completeSale(pos),
      ),
    );
  }
}
