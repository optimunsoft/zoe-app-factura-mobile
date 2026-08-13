import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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

  static const double _cardHeight = 92;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
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
            MoneyText(resumen.carteraGenerada, large: true),
            const SizedBox(height: 2),
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
        ),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      mainAxisExtent: _cardHeight,
      children: cards,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: AppTextStyles.caption)),
            ],
          ),
          const SizedBox(height: 6),
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
