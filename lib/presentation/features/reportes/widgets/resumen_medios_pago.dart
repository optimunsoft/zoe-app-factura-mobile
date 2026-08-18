import 'package:flutter/material.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/ingresos_medios_pago_resumen.dart';
import '../../../atoms/money_text.dart';

/// Totales del reporte agrupados por medio de pago.
class ResumenMediosPago extends StatelessWidget {
  const ResumenMediosPago({super.key, required this.resumen});

  final IngresosMediosPagoResumen resumen;

  IconData _iconFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('efectivo')) return Icons.payments_rounded;
    if (lower.contains('transfer')) return Icons.swap_horiz_rounded;
    if (lower.contains('tarjeta') || lower.contains('card')) {
      return Icons.credit_card_rounded;
    }
    return Icons.account_balance_wallet_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            border: AppBorders.subtle,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total ingresos',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    MoneyText(
                      resumen.totalIngresos,
                      large: true,
                    ),
                  ],
                ),
              ),
              Text(
                '${resumen.cantidadVentas} ${resumen.cantidadVentas == 1 ? 'venta' : 'ventas'}',
                style: AppTextStyles.label,
              ),
            ],
          ),
        ),
        if (resumen.totalesPorMedio.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ...resumen.totalesPorMedio.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.mdAll,
                  border: AppBorders.subtle,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppRadius.smAll,
                      ),
                      child: Icon(
                        _iconFor(t.name),
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: AppTextStyles.label),
                          Text(
                            '${t.lineCount} ${t.lineCount == 1 ? 'pago' : 'pagos'}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    MoneyText(t.amount),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (resumen.ventasSinDesglose > 0) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${resumen.ventasSinDesglose} ${resumen.ventasSinDesglose == 1 ? 'venta' : 'ventas'} sin desglose de medios',
            style: AppTextStyles.caption,
          ),
        ],
      ],
    );
  }
}
