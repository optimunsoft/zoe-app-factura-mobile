import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

class FilaResumen extends StatelessWidget {
  const FilaResumen({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
    this.compact = false,
    this.large = false,
    this.valueColor,
  });

  final String label;
  final num value;
  final bool emphasize;
  final bool compact;
  final bool large;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final labelStyle = emphasize
        ? AppTextStyles.h3
        : large
            ? AppTextStyles.h3.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              )
            : (compact ? AppTextStyles.bodySmall : AppTextStyles.body)
                .copyWith(color: AppColors.textSecondary);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 3 : large ? 8 : 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: labelStyle),
          ),
          MoneyText(
            value,
            style: AppTextStyles.money.copyWith(
              fontSize: 16,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
            ),
            color: valueColor ?? (emphasize ? AppColors.textPrimary : null),
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [FilaResumen].
typedef SummaryRow = FilaResumen;
