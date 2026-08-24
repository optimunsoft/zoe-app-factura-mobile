import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../atoms/money_text.dart';

/// Banner con el monto pendiente / total a pagar.
class BannerMontoPendiente extends StatelessWidget {
  const BannerMontoPendiente({
    super.key,
    required this.label,
    required this.amount,
    this.emphasized = false,
  });

  final String label;
  final double amount;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.primaryLight : AppColors.surfaceAlt,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.selectable(selected: emphasized),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: emphasized ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
          MoneyText(amount, large: emphasized, uniformDecimals: true),
        ],
      ),
    );
  }
}
