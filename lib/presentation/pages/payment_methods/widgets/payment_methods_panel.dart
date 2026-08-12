import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../../modules/method_payments/domain/models/method_payments.models.dart';
import 'payment_option_tile.dart';

/// Listado compacto de medios: solo el seleccionado muestra el editor.
class PaymentMethodsPanel extends StatefulWidget {
  const PaymentMethodsPanel({
    super.key,
    required this.items,
    required this.controllers,
    required this.lockedIds,
    required this.confirmedAmounts,
    required this.total,
    required this.onAdd,
    required this.onEdit,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<MethodPayment> items;
  final Map<int, TextEditingController> controllers;
  final Set<int> lockedIds;
  final Map<int, double> confirmedAmounts;
  final double total;
  final bool Function(MethodPayment method) onAdd;
  final void Function(MethodPayment method) onEdit;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  State<PaymentMethodsPanel> createState() => _PaymentMethodsPanelState();
}

class _PaymentMethodsPanelState extends State<PaymentMethodsPanel> {
  int? _activeId;

  IconData _iconFor(MethodPayment item) {
    if (item.isCash) return Icons.payments_rounded;
    if (item.isTransfer) return Icons.account_balance_rounded;
    return Icons.payment_rounded;
  }

  double get _paid => CurrencyFormat.roundMoney(
        widget.confirmedAmounts.values.fold(0.0, (sum, a) => sum + a),
      );

  double get _remaining {
    final left = CurrencyFormat.roundMoney(widget.total - _paid);
    return left < 0 ? 0 : left;
  }

  double _remainingFor(MethodPayment item) {
    final own = widget.confirmedAmounts[item.id] ?? 0;
    final left = CurrencyFormat.roundMoney(widget.total - (_paid - own));
    return left < 0 ? 0 : left;
  }

  void _select(MethodPayment item) {
    setState(() {
      _activeId = _activeId == item.id ? null : item.id;
    });
  }

  void _handleAdd(MethodPayment item) {
    if (widget.onAdd(item)) {
      setState(() => _activeId = null);
    }
  }

  void _handleEdit(MethodPayment item) {
    widget.onEdit(item);
    setState(() => _activeId = item.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Text('Medios de pago', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        _RemainingBanner(remaining: _remaining),
        const SizedBox(height: 10),
        ...widget.items.map(
          (item) {
            final locked = widget.lockedIds.contains(item.id);
            final expanded = _activeId == item.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PaymentOptionTile(
                label: item.name,
                icon: _iconFor(item),
                amountController: widget.controllers[item.id]!,
                locked: locked,
                expanded: expanded,
                confirmedAmount: widget.confirmedAmounts[item.id],
                remainingHint: expanded && !locked ? _remainingFor(item) : null,
                onSelect: () => _select(item),
                onAdd: () => _handleAdd(item),
                onEdit: () => _handleEdit(item),
              ),
            );
          },
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
