import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/sale_receipt.dart';

class StatusTag extends StatelessWidget {
  const StatusTag({super.key, required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final paid = status == InvoiceStatus.paid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: paid ? AppColors.successBg : AppColors.dangerBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.caption.copyWith(
          color: paid ? AppColors.success : AppColors.danger,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
