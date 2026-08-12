import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/product.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/pct_retention_dropdown.dart';
import 'summary_row.dart';

/// Resumen de compra al estilo del checkout (detalle + retenciones + total).
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
    this.fillHeight = false,
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
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de la compra', style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(
                    'Revisa el detalle de tu compra y continúa',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SummaryRow(label: 'Subtotal', value: subtotal, large: true),
                  if (taxBreakdown.isEmpty)
                    const SummaryRow(label: 'Impuestos', value: 0, large: true)
                  else
                    ...taxBreakdown.map(
                      (t) => SummaryRow(
                        label: t.label,
                        value: t.amount,
                        large: true,
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: AppColors.border),
                  ),
                  SummaryRow(
                    label: 'Total bruto',
                    value: total,
                    emphasize: true,
                  ),
                  const SizedBox(height: 12),
                  _RetentionsPanel(
                    reteIvaOptions: reteIvaOptions,
                    reteIcaOptions: reteIcaOptions,
                    selectedReteIva: selectedReteIva,
                    selectedReteIca: selectedReteIca,
                    reteIvaAmount: reteIvaAmount,
                    reteIcaAmount: reteIcaAmount,
                    reteFuenteAmount: reteFuenteAmount,
                    onReteIvaChanged: onReteIvaChanged,
                    onReteIcaChanged: onReteIcaChanged,
                    onOpenReteFuente: onOpenReteFuente,
                  ),
                  if (fillHeight) const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  xl: true,
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

class _RetentionsPanel extends StatelessWidget {
  const _RetentionsPanel({
    required this.reteIvaOptions,
    required this.reteIcaOptions,
    required this.selectedReteIva,
    required this.selectedReteIca,
    required this.reteIvaAmount,
    required this.reteIcaAmount,
    required this.reteFuenteAmount,
    required this.onReteIvaChanged,
    required this.onReteIcaChanged,
    required this.onOpenReteFuente,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(
              Icons.percent_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Retenciones',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: ' (aplicables)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppColors.primary.withValues(alpha: 0.75),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _RetentionRow(
          name: 'ReteIVA',
          options: reteIvaOptions,
          selected: selectedReteIva,
          amount: reteIvaAmount,
          onChanged: onReteIvaChanged,
        ),
        const SizedBox(height: 12),
        _RetentionRow(
          name: 'ReteICA',
          options: reteIcaOptions,
          selected: selectedReteIca,
          amount: reteIcaAmount,
          onChanged: onReteIcaChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onOpenReteFuente,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(
                    'ReteFuente',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 120,
              child: Align(
                alignment: Alignment.centerRight,
                child: MoneyText(
                  reteFuenteAmount > 0 ? -reteFuenteAmount : 0,
                  style: AppTextStyles.moneyLg.copyWith(fontSize: 18),
                  color: reteFuenteAmount > 0
                      ? AppColors.danger
                      : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ],
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
        Expanded(
          child: Text(
            _label,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: PctRetentionDropdown(
            selected: selected,
            options: options,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Align(
            alignment: Alignment.centerRight,
            child: MoneyText(
              amount > 0 ? -amount : 0,
              style: AppTextStyles.moneyLg.copyWith(fontSize: 18),
              color: amount > 0 ? AppColors.danger : AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
