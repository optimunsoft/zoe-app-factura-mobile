import 'package:flutter/material.dart';

import '../../../../core/layout/ancho_vista.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/ventas_resumen.models.dart';
import '../../../atoms/money_text.dart';

/// Tarjetas estadísticas del resumen de ventas (inicio / reportes).
class TarjetasResumenReportes extends StatelessWidget {
  const TarjetasResumenReportes({
    super.key,
    required this.resumen,
    this.isLoading = false,
  });

  final VentasResumen resumen;
  final bool isLoading;

  static const double _cardHeight = 100;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final cards = <Widget>[
      _MetricCard(
        label: 'Total impuestos',
        icon: Icons.account_balance_rounded,
        child: MoneyText(
          resumen.totalizado.totalImpuestos,
          large: true,
          uniformDecimals: true,
        ),
      ),
      _MetricCard(
        label: 'Nº de facturas',
        icon: Icons.receipt_long_rounded,
        child: Text(
          '${resumen.cantidadFacturas}',
          style: AppTextStyles.moneyLg,
        ),
      ),
      _MetricCard(
        label: 'Cartera generada',
        icon: Icons.account_balance_wallet_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MoneyText(
              resumen.carteraGenerada,
              large: true,
              uniformDecimals: true,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${resumen.porcentajeCartera.toStringAsFixed(
                resumen.porcentajeCartera % 1 == 0 ? 0 : 1,
              )}% cartera',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      _MetricCard(
        label: 'Total retenciones',
        icon: Icons.percent_rounded,
        child: MoneyText(
          resumen.totalizado.totalRetenciones,
          large: true,
          uniformDecimals: true,
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = AnchoVista.columnasResumen(constraints.maxWidth);
        return GridView.count(
          crossAxisCount: crossCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          mainAxisExtent: _cardHeight,
          children: cards,
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.child,
    required this.icon,
  });

  final String label;
  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: AppTextStyles.caption)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [TarjetasResumenReportes].
typedef ReportsSummaryCards = TarjetasResumenReportes;
