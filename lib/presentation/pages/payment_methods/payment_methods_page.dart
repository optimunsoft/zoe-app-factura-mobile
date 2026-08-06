import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/payment_method.dart';
import '../../../modules/method_payments/domain/models/method_payments.models.dart';
import '../../../modules/method_payments/store/method_payments.store.dart';
import 'widgets/payment_methods_panel.dart';
import 'widgets/payment_summary_footer.dart';

/// Pantalla 2 — Formas de pago (API medios de pago).
class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final _cashCtrl = TextEditingController();
  double _cashReceived = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MethodPaymentsStore>().loadAll();
    });
  }

  @override
  void dispose() {
    _cashCtrl.dispose();
    super.dispose();
  }

  PaymentMethod _toPosMethod(MethodPayment item) {
    if (item.isCash) return PaymentMethod.cash;
    if (item.isTransfer) return PaymentMethod.transfer;
    return PaymentMethod.mixed;
  }

  void _completeSale(PosController pos, MethodPayment? selected) {
    if (pos.itemCount == 0 || selected == null) return;

    final method = _toPosMethod(selected);
    final needsCash = selected.isCash;

    if (needsCash && _cashReceived < pos.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El efectivo recibido es insuficiente')),
      );
      return;
    }

    pos.completeSale(
      method: method,
      cashReceived: needsCash ? _cashReceived : null,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final store = context.watch<MethodPaymentsStore>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Formas de pago', style: AppTextStyles.h2),
      ),
      body: _buildBody(store),
      bottomNavigationBar: PaymentSummaryFooter(
        subtotal: pos.subtotal,
        taxBreakdown: pos.taxBreakdown,
        total: pos.total,
        canComplete: pos.itemCount > 0 && store.selected != null,
        onComplete: () => _completeSale(pos, store.selected),
      ),
    );
  }

  Widget _buildBody(MethodPaymentsStore store) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                store.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => store.loadAll(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (store.items.isEmpty) {
      return Center(
        child: Text(
          'No hay medios de pago configurados',
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return PaymentMethodsPanel(
      items: store.items,
      selected: store.selected,
      onChanged: store.select,
      total: context.watch<PosController>().total,
      cashController: _cashCtrl,
      cashReceived: _cashReceived,
      onCashChanged: (v) {
        setState(() {
          _cashReceived = CurrencyFormat.parseInput(v);
        });
      },
    );
  }
}
