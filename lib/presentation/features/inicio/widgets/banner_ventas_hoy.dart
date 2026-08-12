import 'package:flutter/material.dart';

import '../../../../data/mock_catalog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Banner con resumen de ventas del día en el dashboard.
class BannerVentasHoy extends StatelessWidget {
  const BannerVentasHoy({super.key});

  @override
  Widget build(BuildContext context) {
    final report = MockCatalog.todayReport;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoy',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${report.totalSales.toStringAsFixed(2)}',
                  style: AppTextStyles.moneyXl.copyWith(color: Colors.white),
                ),
                Text(
                  '${report.invoiceCount} facturas · IVA \$${report.taxCollected.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Icon(Icons.trending_up_rounded, color: Colors.white, size: 40),
        ],
      ),
    );
  }
}
