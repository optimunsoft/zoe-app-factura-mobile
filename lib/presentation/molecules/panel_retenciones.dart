import 'package:flutter/material.dart';

import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/taxes/domain/models/taxes.models.dart';
import '../atoms/money_text.dart';
import '../atoms/pct_retention_dropdown.dart';

/// Fila unificada de retención: nombre · control · monto.
class FilaRetencion extends StatelessWidget {
  const FilaRetencion({
    super.key,
    required this.name,
    required this.amount,
    this.options = const [],
    this.selected,
    this.onChanged,
    this.onEdit,
    this.editLabel = 'Editar',
  });

  final String name;
  final double amount;
  final List<TaxRetention> options;
  final TaxRetention? selected;
  final ValueChanged<TaxRetention?>? onChanged;

  /// Si se define, muestra botón de acción en lugar del dropdown (ReteFuente).
  final VoidCallback? onEdit;
  final String editLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (onEdit != null)
            _EditChip(label: editLabel, onTap: onEdit!)
          else
            PctRetentionDropdown(
              selected: selected,
              options: options,
              onChanged: onChanged,
            ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 110,
            child: Align(
              alignment: Alignment.centerRight,
              child: amount > 0
                  ? MoneyText(
                      -amount,
                      style: AppTextStyles.money.copyWith(fontSize: 16),
                      color: AppColors.danger,
                    )
                  : Text(
                      '—',
                      style: AppTextStyles.money.copyWith(
                        fontSize: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditChip extends StatelessWidget {
  const _EditChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        borderRadius: AppRadius.smAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primaryDark,
              fontSize: 12,
            ),
          ),
        ),
      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.percent_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Retenciones',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                  ),
                ),
              ),
              Tooltip(
                message: 'Se restan del total bruto al calcular el total a pagar.',
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.primary.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilaRetencion(
            name: 'ReteIVA',
            options: reteIvaOptions,
            selected: selectedReteIva,
            amount: reteIvaAmount,
            onChanged: onReteIvaChanged,
          ),
          FilaRetencion(
            name: 'ReteICA',
            options: reteIcaOptions,
            selected: selectedReteIca,
            amount: reteIcaAmount,
            onChanged: onReteIcaChanged,
          ),
          FilaRetencion(
            name: 'ReteFuente',
            amount: reteFuenteAmount,
            onEdit: onOpenReteFuente,
          ),
        ],
      ),
    );
  }
}
