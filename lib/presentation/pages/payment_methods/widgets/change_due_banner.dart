import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

class ChangeDueBanner extends StatelessWidget {
  const ChangeDueBanner({super.key, required this.change});

  final double change;

  @override
  Widget build(BuildContext context) {
    final ok = change >= 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ok ? AppColors.successBg : AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Cambio',
              style: AppTextStyles.label.copyWith(
                color: ok ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
          MoneyText(
            change < 0 ? 0 : change,
            large: true,
            color: ok ? AppColors.success : AppColors.warning,
          ),
        ],
      ),
    );
  }
}
