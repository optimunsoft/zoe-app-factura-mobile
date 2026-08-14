import 'package:flutter/material.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../atoms/app_button.dart';

/// Pie fijo: solo el CTA de completar venta.
class PieResumenPago extends StatelessWidget {
  const PieResumenPago({
    super.key,
    required this.onComplete,
    this.canComplete = true,
    this.isSubmitting = false,
    this.completeLabel = 'Completar venta e imprimir',
  });

  final VoidCallback? onComplete;
  final bool canComplete;
  final bool isSubmitting;
  final String completeLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: AppBorders.top,
          boxShadow: AppShadows.bar,
        ),
        child: AppButton(
          label: isSubmitting ? 'Emitiendo venta...' : completeLabel,
          icon: isSubmitting ? null : Icons.print_rounded,
          onPressed: (canComplete && !isSubmitting) ? onComplete : null,
        ),
      ),
    );
  }
}

/// Alias legacy — usar [PieResumenPago].
typedef PaymentSummaryFooter = PieResumenPago;
