import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/app_button.dart';
import '../../../atoms/money_text.dart';

/// Barra inferior del carrito: total acumulado + CTA "Pagar".
class CheckoutPayBar extends StatelessWidget {
  const CheckoutPayBar({
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
