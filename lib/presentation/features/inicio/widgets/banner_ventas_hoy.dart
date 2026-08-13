import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total ventas',
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          periodLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        if (onTap != null) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.expand_more_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
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
