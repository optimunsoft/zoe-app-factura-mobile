import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../atoms/money_text.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueColor,
  });

  final String label;
  final num value;
  final bool emphasize;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasize
                  ? AppTextStyles.h3
                  : AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          MoneyText(
            value,
            large: emphasize,
            color: valueColor ?? (emphasize ? AppColors.textPrimary : null),
          ),
        ],
      ),
    );
  }
}
