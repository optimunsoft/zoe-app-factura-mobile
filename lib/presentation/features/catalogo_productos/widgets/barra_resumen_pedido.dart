import 'package:flutter/material.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

class BarraResumenPedido extends StatelessWidget {
  const BarraResumenPedido({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onReviewPay,
  });

  final int itemCount;
  final double total;
  final VoidCallback onReviewPay;

  @override
  Widget build(BuildContext context) {
    final enabled = itemCount > 0;

    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            border: AppBorders.top,
            boxShadow: AppShadows.bar,
          ),
          child: InkWell(
            onTap: enabled ? onReviewPay : null,
            borderRadius: AppRadius.mdAll,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                children: [
                  Text('Total', style: AppTextStyles.h3),
                  const Spacer(),
                  Opacity(
                    opacity: enabled ? 1 : 0.45,
                    child: MoneyText(
                      total,
                      large: true,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: enabled
                          ? AppColors.primary
                          : AppColors.surfaceAlt,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 22,
                      color: enabled ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [BarraResumenPedido].
typedef OrderSummaryBar = BarraResumenPedido;
