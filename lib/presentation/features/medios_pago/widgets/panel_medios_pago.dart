import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../../modules/method_payments/domain/models/method_payments.models.dart';
import 'tarjeta_opcion_pago.dart';

/// Listado compacto de medios: solo el seleccionado muestra el editor.
class PanelMediosPago extends StatefulWidget {
  const PanelMediosPago({
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
  State<PanelMediosPago> createState() => _PanelMediosPagoState();
}

class _PanelMediosPagoState extends State<PanelMediosPago> {
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

  void _rellenarPendiente(MethodPayment item) {
    final ctrl = widget.controllers[item.id];
    if (ctrl == null) return;

    final left = _remainingFor(item);
    if (left <= 0.001) {
      ctrl.clear();
      return;
    }

    final text = CurrencyFormat.formatInput(left);
    ctrl.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _select(MethodPayment item) {
    final opening = _activeId != item.id;
    setState(() {
      _activeId = opening ? item.id : null;
    });
    if (opening && !widget.lockedIds.contains(item.id)) {
      _rellenarPendiente(item);
    }
  }

  void _handleAdd(MethodPayment item) {
    if (widget.onAdd(item)) {
      setState(() => _activeId = null);
    }
  }

  void _handleEdit(MethodPayment item) {
    widget.onEdit(item);
    setState(() => _activeId = item.id);
    _rellenarPendiente(item);
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
        _RemainingBanner(
          remaining: _remaining,
          todosLosMediosConMonto: widget.items.isNotEmpty &&
              widget.items.every((i) => widget.lockedIds.contains(i.id)),
        ),
        const SizedBox(height: AppSpacing.md),
        ...widget.items.map(
          (item) {
            final locked = widget.lockedIds.contains(item.id);
            final expanded = _activeId == item.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TarjetaOpcionPago(
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
  const _RemainingBanner({
    required this.remaining,
    required this.todosLosMediosConMonto,
  });

  final double remaining;
  final bool todosLosMediosConMonto;

  @override
  Widget build(BuildContext context) {
    final done = remaining <= 0.001;
    final bloqueadoConFaltante = !done && todosLosMediosConMonto;
    final accent = done ? AppColors.success : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: done ? AppColors.successBg : AppColors.warningBg,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  done
                      ? 'Saldo cubierto'
                      : bloqueadoConFaltante
                          ? 'Medios de pago completos'
                          : 'Por pagar',
                  style: AppTextStyles.label.copyWith(color: accent),
                ),
              ),
              Text(
                CurrencyFormat.money(remaining),
                style: AppTextStyles.moneyLg.copyWith(
                  color: accent,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          if (bloqueadoConFaltante) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ya se llenaron todos los medios de pago y todavía falta '
              '${CurrencyFormat.money(remaining)} por agregar. '
              'Modifica alguno para cubrir el resto.',
              style: AppTextStyles.bodySmall.copyWith(color: accent),
            ),
          ],
        ],
      ),
    );
  }
}

/// Alias legacy — usar [PanelMediosPago].
typedef PaymentMethodsPanel = PanelMediosPago;
