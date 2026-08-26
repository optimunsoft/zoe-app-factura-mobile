import 'package:flutter/material.dart';

import '../../../../core/layout/ancho_vista.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
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

  /// Alto fijo en tablet (vertical y horizontal) y escritorio.
  static const double _alturaCompacta = 80;

  @override
  Widget build(BuildContext context) {
    final compacto = AnchoVista.esTabletDispositivo(context);
    final tarjetas = [
      TarjetaAcceso(
        title: 'Nueva venta',
        subtitle: 'Abrir catálogo POS',
        icon: Icons.add_shopping_cart_rounded,
        onTap: onNewSale,
        compacto: compacto,
      ),
      TarjetaAcceso(
        title: 'Facturas',
        subtitle: 'Historial de ventas',
        icon: Icons.receipt_long_rounded,
        accent: AppColors.primaryDark,
        onTap: onReceipts,
        compacto: compacto,
      ),
      TarjetaAcceso(
        title: 'Reportes',
        subtitle: 'Resumen y métricas',
        icon: Icons.bar_chart_rounded,
        accent: AppColors.success,
        onTap: onReports,
        compacto: compacto,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Accesos rápidos', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.count(
              crossAxisCount: AnchoVista.columnasAccesos(
                context,
                constraints.maxWidth,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: compacto ? AppSpacing.sm : AppSpacing.md,
              crossAxisSpacing: compacto ? AppSpacing.sm : AppSpacing.md,
              mainAxisExtent: compacto ? _alturaCompacta : null,
              childAspectRatio: 1.2,
              children: tarjetas,
            );
          },
        ),
      ],
    );
  }
}
