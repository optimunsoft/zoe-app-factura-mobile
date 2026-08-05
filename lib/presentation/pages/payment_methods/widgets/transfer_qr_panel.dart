import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

class TransferQrPanel extends StatelessWidget {
  const TransferQrPanel({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.qr_code_2_rounded, size: 96, color: AppColors.primary),
          const SizedBox(height: 8),
          Text('Escanea para transferir', style: AppTextStyles.label),
          MoneyText(amount, large: true, color: AppColors.primary),
        ],
      ),
    );
  }
}
