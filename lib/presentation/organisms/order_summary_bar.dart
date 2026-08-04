import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../atoms/money_text.dart';

class OrderSummaryBar extends StatelessWidget {
  const OrderSummaryBar({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.onReviewPay,
  });

  final int itemCount;
  final double subtotal;
  final double tax;
  final double total;
  final VoidCallback onReviewPay;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + bottom),
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
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$itemCount art. · Subt. + IVA',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('Sub ', style: AppTextStyles.caption),
                          MoneyText(subtotal),
                          Text('  ·  IVA ', style: AppTextStyles.caption),
                          MoneyText(tax),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total', style: AppTextStyles.caption),
                    MoneyText(total, large: true, color: AppColors.primary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: AppTextStyles.button.copyWith(fontSize: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: itemCount > 0 ? onReviewPay : null,
                child: const Text('Revisar y pagar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
