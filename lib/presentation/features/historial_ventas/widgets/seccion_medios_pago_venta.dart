import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/list_sales.models.dart';
import '../../../atoms/money_text.dart';

/// Listado de medios de pago de una venta.
class SeccionMediosPagoVenta extends StatelessWidget {
  const SeccionMediosPagoVenta({super.key, required this.sale});

  final ListSales sale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Medios de pago', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.sm),
        if (sale.paymentDetails.isEmpty)
          Text('Sin detalle de pago', style: AppTextStyles.bodySmall)
        else
          ...sale.paymentDetails.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(p.name, style: AppTextStyles.label),
                    ),
                    MoneyText(p.amount),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Alias legacy — usar [SeccionMediosPagoVenta].
typedef MediosPagoVentaSection = SeccionMediosPagoVenta;
