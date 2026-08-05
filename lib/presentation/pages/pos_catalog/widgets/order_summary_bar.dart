import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

class OrderSummaryBar extends StatelessWidget {
  const OrderSummaryBar({
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
    final bottom = MediaQuery.paddingOf(context).bottom;
    final enabled = itemCount > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 12, 12 + bottom),
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
        child: InkWell(
          onTap: enabled ? onReviewPay : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
    );
  }
}
