import 'package:flutter/material.dart';
import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/payment_method.dart';

class InterruptorPago extends StatelessWidget {
  const InterruptorPago({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: Row(
        children: PaymentMethod.values.map((method) {
          final selected = method == value;
          final icon = switch (method) {
            PaymentMethod.cash => Icons.payments_rounded,
            PaymentMethod.transfer => Icons.qr_code_2_rounded,
            PaymentMethod.mixed => Icons.swap_horiz_rounded,
          };
          return Expanded(
            child: Material(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: AppRadius.smAll,
              child: InkWell(
                onTap: () => onChanged(method),
                borderRadius: AppRadius.smAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: selected ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method.label,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Alias legacy — usar [InterruptorPago].
typedef PaymentToggle = InterruptorPago;
