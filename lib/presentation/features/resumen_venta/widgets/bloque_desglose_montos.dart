import 'package:flutter/material.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/product.dart';
import 'fila_resumen.dart';

/// Bloque de solo lectura: subtotal → impuestos → total bruto.
class BloqueDesgloseMontos extends StatelessWidget {
  const BloqueDesgloseMontos({
    super.key,
    required this.subtotal,
    required this.taxBreakdown,
    required this.total,
  });

  final double subtotal;
  final List<TaxBreakdownLine> taxBreakdown;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: AppBorders.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Desglose', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          FilaResumen(label: 'Subtotal', value: subtotal, compact: true),
          if (taxBreakdown.isEmpty)
            const FilaResumen(label: 'Impuestos', value: 0, compact: true)
          else
            ...taxBreakdown.map(
              (t) => FilaResumen(
                label: t.label,
                value: t.amount,
                compact: true,
                valueColor: AppColors.textSecondary,
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(),
          ),
          FilaResumen(
            label: 'Total bruto',
            value: total,
            emphasize: true,
          ),
        ],
      ),
    );
  }
}
