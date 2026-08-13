import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'tarjeta_acceso.dart';

/// Grilla de accesos rápidos del dashboard.
class GrillaAccesosRapidos extends StatelessWidget {
  const GrillaAccesosRapidos({
    super.key,
    required this.onNewSale,
    required this.onReceipts,
    required this.onReports,
  });

  final VoidCallback onNewSale;
  final VoidCallback onReceipts;
  final VoidCallback onReports;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Accesos rápidos', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            TarjetaAcceso(
              title: 'Nueva venta',
              subtitle: 'Abrir catálogo POS',
              icon: Icons.add_shopping_cart_rounded,
              onTap: onNewSale,
            ),
            TarjetaAcceso(
              title: 'Facturas',
              subtitle: 'Historial de ventas',
              icon: Icons.receipt_long_rounded,
              accent: AppColors.primaryDark,
              onTap: onReceipts,
            ),
            TarjetaAcceso(
              title: 'Reportes',
              subtitle: 'Resumen y métricas',
              icon: Icons.bar_chart_rounded,
              accent: AppColors.success,
              onTap: onReports,
            ),
          ],
        ),
      ],
    );
  }
}
