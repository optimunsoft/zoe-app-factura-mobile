import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_payment_methods.dart';
import '../../domain/models/payment_method.dart';
import '../molecules/cash_amount_field.dart';
import '../molecules/change_due_banner.dart';
import '../molecules/payment_option_tile.dart';
import '../molecules/transfer_qr_panel.dart';

/// Organismo con listado de formas de pago + paneles contextuales.
class PaymentMethodsPanel extends StatelessWidget {
  const PaymentMethodsPanel({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.total,
    required this.cashController,
    required this.cashReceived,
    required this.onCashChanged,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;
  final double total;
  final TextEditingController cashController;
  final double cashReceived;
  final ValueChanged<String> onCashChanged;

  @override
  Widget build(BuildContext context) {
    final showCash =
        selected == PaymentMethod.cash || selected == PaymentMethod.mixed;
    final showQr = selected == PaymentMethod.transfer;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text('Elige una forma de pago', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        ...MockPaymentMethods.options.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PaymentOptionTile(
              option: option,
              selected: option.method == selected,
              onTap: () => onChanged(option.method),
            ),
          );
        }),
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
