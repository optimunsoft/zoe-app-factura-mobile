import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/product.dart';
import '../../../atoms/app_button.dart';
import 'checkout_summary_card.dart';

/// Pie de la pantalla de pago: resumen + completar venta.
class PaymentSummaryFooter extends StatelessWidget {
  const PaymentSummaryFooter({
    super.key,
    required this.subtotal,
    required this.taxBreakdown,
    required this.total,
    required this.onComplete,
    this.canComplete = true,
  });

  final double subtotal;
  final List<TaxBreakdownLine> taxBreakdown;
  final double total;
  final VoidCallback? onComplete;
  final bool canComplete;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckoutSummaryCard(
              subtotal: subtotal,
              taxBreakdown: taxBreakdown,
              total: total,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Completar venta e imprimir',
              icon: Icons.print_rounded,
              onPressed: canComplete ? onComplete : null,
            ),
          ],
        ),
      ),
    );
  }
}
