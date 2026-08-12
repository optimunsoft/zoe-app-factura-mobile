import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
