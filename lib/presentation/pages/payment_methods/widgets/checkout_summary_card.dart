import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/product.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/pct_retention_dropdown.dart';
import 'summary_row.dart';

class CheckoutSummaryCard extends StatelessWidget {
  const CheckoutSummaryCard({
    super.key,
    required this.subtotal,
    required this.taxBreakdown,
    required this.total,
    required this.payableTotal,
    this.reteIvaOptions = const [],
    this.reteIcaOptions = const [],
    this.selectedReteIva,
    this.selectedReteIca,
    this.reteIvaAmount = 0,
    this.reteIcaAmount = 0,
    this.reteFuenteAmount = 0,
    this.onReteIvaChanged,
    this.onReteIcaChanged,
    this.onOpenReteFuente,
  });

  final double subtotal;
  final List<TaxBreakdownLine> taxBreakdown;
  final double total;
  final double payableTotal;

  final List<TaxRetention> reteIvaOptions;
  final List<TaxRetention> reteIcaOptions;
  final TaxRetention? selectedReteIva;
  final TaxRetention? selectedReteIca;
  final double reteIvaAmount;
  final double reteIcaAmount;
  final double reteFuenteAmount;
  final ValueChanged<TaxRetention?>? onReteIvaChanged;
  final ValueChanged<TaxRetention?>? onReteIcaChanged;
  final VoidCallback? onOpenReteFuente;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen de la compra', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                SummaryRow(label: 'Subtotal', value: subtotal),
                if (taxBreakdown.isEmpty)
                  const SummaryRow(label: 'Impuestos', value: 0)
                else
                  ...taxBreakdown.map(
                    (t) => SummaryRow(label: t.label, value: t.amount),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                _RetentionRow(
                  name: 'ReteIVA',
                  options: reteIvaOptions,
                  selected: selectedReteIva,
                  amount: reteIvaAmount,
                  onChanged: onReteIvaChanged,
                ),
                const SizedBox(height: 10),
                _RetentionRow(
                  name: 'ReteICA',
                  options: reteIcaOptions,
                  selected: selectedReteIca,
                  amount: reteIcaAmount,
                  onChanged: onReteIcaChanged,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onOpenReteFuente,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            'ReteFuente',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    MoneyText(
                      reteFuenteAmount > 0 ? -reteFuenteAmount : 0,
                      color: reteFuenteAmount > 0
                          ? AppColors.danger
                          : AppColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total a pagar',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                MoneyText(
                  payableTotal,
                  large: true,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RetentionRow extends StatelessWidget {
  const _RetentionRow({
    required this.name,
    required this.options,
    required this.selected,
    required this.amount,
    required this.onChanged,
  });

  final String name;
  final List<TaxRetention> options;
  final TaxRetention? selected;
  final double amount;
  final ValueChanged<TaxRetention?>? onChanged;

  String _formatPct(double value) {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String get _label {
    final pct = selected?.percentageValue ?? 0;
    return '$name (${_formatPct(pct)}%)';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _label,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        PctRetentionDropdown(
          selected: selected,
          options: options,
          onChanged: onChanged,
        ),
        const Spacer(),
        MoneyText(
          amount > 0 ? -amount : 0,
          color: amount > 0 ? AppColors.danger : AppColors.textMuted,
        ),
      ],
    );
  }
}
