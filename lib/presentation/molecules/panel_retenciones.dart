import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/taxes/domain/checkout_tax_calculator.dart';
import '../../../modules/taxes/domain/models/taxes.models.dart';
import '../atoms/money_text.dart';
import '../atoms/pct_retention_dropdown.dart';

/// Fila de retención (nombre + % + monto).
class FilaRetencion extends StatelessWidget {
  const FilaRetencion({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    final pct = selected?.percentageValue ?? 0;
    final label = '$name (${CheckoutTaxCalculator.formatPct(pct)}%)';

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
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

/// Panel de retenciones aplicables (ReteIVA / ReteICA / ReteFuente).
class PanelRetenciones extends StatelessWidget {
  const PanelRetenciones({
    super.key,
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
        FilaRetencion(
          name: 'ReteIVA',
          options: reteIvaOptions,
          selected: selectedReteIva,
          amount: reteIvaAmount,
          onChanged: onReteIvaChanged,
        ),
        const SizedBox(height: 12),
        FilaRetencion(
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
