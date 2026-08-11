import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/product.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../atoms/app_button.dart';
import 'checkout_summary_card.dart';

/// Pie de la pantalla de pago: resumen + completar venta.
class PaymentSummaryFooter extends StatelessWidget {
  const PaymentSummaryFooter({
    super.key,
    required this.subtotal,
    required this.taxBreakdown,
    required this.total,
    required this.payableTotal,
    required this.onComplete,
    this.canComplete = true,
    this.reteIvaOptions = const [],
    this.reteIcaOptions = const [],
    this.selectedReteIva,
    this.selectedReteIca,
    this.reteIvaAmount = 0,
    this.reteIcaAmount = 0,
    this.reteFuenteAmount = 0,
    this.onReteIvaChanged,
    this.onReteIcaChanged,
    this.onOpenReteFuente,
  });

  final double subtotal;
  final List<TaxBreakdownLine> taxBreakdown;
  final double total;
  final double payableTotal;
  final VoidCallback? onComplete;
  final bool canComplete;

  final List<TaxRetention> reteIvaOptions;
  final List<TaxRetention> reteIcaOptions;
  final TaxRetention? selectedReteIva;
  final TaxRetention? selectedReteIca;
  final double reteIvaAmount;
  final double reteIcaAmount;
  final double reteFuenteAmount;
  final ValueChanged<TaxRetention?>? onReteIvaChanged;
  final ValueChanged<TaxRetention?>? onReteIcaChanged;
  final VoidCallback? onOpenReteFuente;

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
              payableTotal: payableTotal,
              reteIvaOptions: reteIvaOptions,
              reteIcaOptions: reteIcaOptions,
              selectedReteIva: selectedReteIva,
              selectedReteIca: selectedReteIca,
              reteIvaAmount: reteIvaAmount,
              reteIcaAmount: reteIcaAmount,
              reteFuenteAmount: reteFuenteAmount,
              onReteIvaChanged: onReteIvaChanged,
              onReteIcaChanged: onReteIcaChanged,
              onOpenReteFuente: onOpenReteFuente,
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
