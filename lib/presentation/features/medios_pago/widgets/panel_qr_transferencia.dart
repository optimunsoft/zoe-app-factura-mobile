import 'package:flutter/material.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

class PanelQrTransferencia extends StatelessWidget {
  const PanelQrTransferencia({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: AppBorders.subtle,
      ),
      child: Column(
        children: [
          const Icon(Icons.qr_code_2_rounded, size: 96, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text('Escanea para transferir', style: AppTextStyles.label),
          MoneyText(amount, large: true, color: AppColors.primary),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [PanelQrTransferencia].
typedef TransferQrPanel = PanelQrTransferencia;
