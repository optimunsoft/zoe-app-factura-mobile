import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/ventas_resumen.models.dart';
import '../../../atoms/money_text.dart';

/// Banner Total ventas; al tocar abre el filtro de periodo.
class BannerVentasHoy extends StatelessWidget {
  const BannerVentasHoy({
    super.key,
    required this.resumen,
    required this.periodLabel,
    this.isLoading = false,
    this.onTap,
  });

  final VentasResumen resumen;
  final String periodLabel;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.lgAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.oscuro
                    ? AppColors.background
                    : AppColors.primaryDark,
              ],
            ),
            borderRadius: AppRadius.lgAll,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total ventas',
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          periodLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        if (onTap != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            Icons.expand_more_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      MoneyText(
                        resumen.facturado,
                        style: AppTextStyles.moneyLg.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        color: Colors.white,
                        uniformDecimals: true,
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
