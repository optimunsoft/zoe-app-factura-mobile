import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/method_payments/domain/models/method_payments.models.dart';
import 'cash_amount_field.dart';
import 'change_due_banner.dart';
import 'payment_option_tile.dart';
import 'transfer_qr_panel.dart';

/// Listado de medios de pago (API) + paneles contextuales.
class PaymentMethodsPanel extends StatelessWidget {
  const PaymentMethodsPanel({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
    required this.total,
    required this.cashController,
    required this.cashReceived,
    required this.onCashChanged,
  });

  final List<MethodPayment> items;
  final MethodPayment? selected;
  final ValueChanged<MethodPayment> onChanged;
  final double total;
  final TextEditingController cashController;
  final double cashReceived;
  final ValueChanged<String> onCashChanged;

  IconData _iconFor(MethodPayment item) {
    if (item.isCash) return Icons.payments_rounded;
    if (item.isTransfer) return Icons.account_balance_rounded;
    return Icons.payment_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final showCash = selected?.isCash == true;
    final showQr = selected?.isTransfer == true;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text('Elige una forma de pago', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PaymentOptionTile(
              label: item.name,
              description: 'ID ${item.id}',
              icon: _iconFor(item),
              selected: selected?.id == item.id,
              onTap: () => onChanged(item),
            ),
          ),
        ),
        if (showCash) ...[
          const SizedBox(height: 8),
          CashAmountField(
            controller: cashController,
            onChanged: onCashChanged,
          ),
          const SizedBox(height: 10),
          ChangeDueBanner(change: cashReceived - total),
        ],
        if (showQr) ...[
          const SizedBox(height: 8),
          TransferQrPanel(amount: total),
        ],
      ],
    );
  }
}
