import 'package:flutter/material.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/app_button.dart';
import '../../../atoms/money_text.dart';

/// Barra inferior del carrito: total acumulado + CTA "Pagar".
class BarraPagarVenta extends StatelessWidget {
  const BarraPagarVenta({
    super.key,
    required this.total,
    required this.itemCount,
    required this.onPay,
  });

  final double total;
  final int itemCount;
  final VoidCallback? onPay;

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
          border: AppBorders.top,
          boxShadow: AppShadows.bar,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$itemCount artículo${itemCount == 1 ? '' : 's'}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                Text('Total', style: AppTextStyles.caption),
                const SizedBox(width: 8),
                MoneyText(total, large: true, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Pagar',
              icon: Icons.payments_rounded,
              onPressed: onPay,
            ),
          ],
        ),
      ),
    );
  }
}

/// Alias legacy — usar [BarraPagarVenta].
typedef CheckoutPayBar = BarraPagarVenta;
