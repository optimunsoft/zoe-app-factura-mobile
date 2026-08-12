import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'tarjeta_acceso.dart';

/// Grilla de accesos rápidos del dashboard.
class GrillaAccesosRapidos extends StatelessWidget {
  const GrillaAccesosRapidos({
    super.key,
    required this.onNewSale,
    required this.onDailySummary,
    required this.onInventory,
    required this.onReceipts,
  });

  final VoidCallback onNewSale;
  final VoidCallback onDailySummary;
  final VoidCallback onInventory;
  final VoidCallback onReceipts;

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
          childAspectRatio: 1.05,
          children: [
            TarjetaAcceso(
              title: 'Nueva venta',
              subtitle: 'Abrir catálogo POS',
              icon: Icons.add_shopping_cart_rounded,
              onTap: onNewSale,
            ),
            TarjetaAcceso(
              title: 'Resumen diario',
              subtitle: 'Z-Report del día',
              icon: Icons.summarize_rounded,
              accent: AppColors.success,
              onTap: onDailySummary,
            ),
            TarjetaAcceso(
              title: 'Inventario',
              subtitle: 'Stock en ruta',
              icon: Icons.inventory_2_rounded,
              accent: AppColors.warning,
              onTap: onInventory,
            ),
            TarjetaAcceso(
              title: 'Historial de ventas',
              subtitle: 'Últimas facturas',
              icon: Icons.receipt_long_rounded,
              accent: AppColors.primaryDark,
              onTap: onReceipts,
            ),
          ],
        ),
      ],
    );
  }
}
