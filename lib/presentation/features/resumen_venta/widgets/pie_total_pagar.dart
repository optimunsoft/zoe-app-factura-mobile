import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/app_button.dart';
import '../../../atoms/money_text.dart';

/// Pie sticky: total a pagar + CTA a formas de pago.
class PieTotalPagar extends StatelessWidget {
  const PieTotalPagar({
    super.key,
    required this.payableTotal,
    required this.onContinue,
    this.canContinue = true,
  });

  final double payableTotal;
  final VoidCallback? onContinue;
  final bool canContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total a pagar',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                MoneyText(
                  payableTotal,
                  xl: true,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Continuar a formas de pago',
              icon: Icons.arrow_forward_rounded,
              onPressed: canContinue ? onContinue : null,
            ),
          ],
        ),
      ),
    );
  }
}
