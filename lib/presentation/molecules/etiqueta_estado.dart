import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/sale_receipt.dart';

class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado({super.key, required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final paid = status == InvoiceStatus.paid;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: paid ? AppColors.successBg : AppColors.dangerBg,
        borderRadius: AppRadius.smAll,
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

/// Alias legacy — usar [EtiquetaEstado].
typedef StatusTag = EtiquetaEstado;
