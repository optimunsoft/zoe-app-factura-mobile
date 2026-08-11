import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../../modules/method_payments/domain/models/method_payments.models.dart';
import 'payment_option_tile.dart';

/// Listado de medios de pago con monto + Añadir/Modificar por cada uno.
class PaymentMethodsPanel extends StatelessWidget {
  const PaymentMethodsPanel({
    super.key,
    required this.items,
    required this.controllers,
    required this.lockedIds,
    required this.confirmedAmounts,
    required this.total,
    required this.onAdd,
    required this.onEdit,
  });

  final List<MethodPayment> items;
  final Map<int, TextEditingController> controllers;
  final Set<int> lockedIds;
  final Map<int, double> confirmedAmounts;
  final double total;
  final void Function(MethodPayment method) onAdd;
  final void Function(MethodPayment method) onEdit;

  IconData _iconFor(MethodPayment item) {
    if (item.isCash) return Icons.payments_rounded;
    if (item.isTransfer) return Icons.account_balance_rounded;
    return Icons.payment_rounded;
  }

  double get _paid =>
      confirmedAmounts.values.fold(0.0, (sum, a) => sum + a);

  double get _remaining {
    final left = total - _paid;
    return left < 0 ? 0 : left;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _RemainingBanner(remaining: _remaining),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PaymentOptionTile(
              label: item.name,
              icon: _iconFor(item),
              amountController: controllers[item.id]!,
              locked: lockedIds.contains(item.id),
              onAdd: () => onAdd(item),
              onEdit: () => onEdit(item),
            ),
          ),
        ),
      ],
    );
  }
}

class _RemainingBanner extends StatelessWidget {
  const _RemainingBanner({required this.remaining});

  final double remaining;

  @override
  Widget build(BuildContext context) {
    final done = remaining <= 0.001;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: done ? AppColors.successBg : AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              done ? 'Saldo cubierto' : 'Por pagar',
              style: AppTextStyles.label.copyWith(
                color: done ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
          Text(
            CurrencyFormat.money(remaining),
            style: AppTextStyles.moneyLg.copyWith(
              color: done ? AppColors.success : AppColors.warning,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
