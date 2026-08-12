import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../../modules/sales/domain/models/list_sales.models.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/product_image_placeholder.dart';

/// Tarjeta de una línea de producto en el detalle de venta.
class LineaProductoVenta extends StatelessWidget {
  const LineaProductoVenta({super.key, required this.detail});

  final ListSalesDetail detail;

  @override
  Widget build(BuildContext context) {
    final taxesLabel = detail.taxes.isEmpty
        ? null
        : detail.taxes.map((t) => '${t.name} ${t.percentage}%').join(' · ');
    final lineTotal = (detail.quantity * detail.unitPrice) - detail.discount;
    final qtyPrice =
        '${detail.quantity} × ${CurrencyFormat.money(detail.unitPrice)}'
        '${detail.discount > 0 ? ' · Desc. ${CurrencyFormat.money(detail.discount)}' : ''}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 56,
              height: 56,
              child: ProductImagePlaceholder(compact: true),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.name, style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  Text(qtyPrice, style: AppTextStyles.bodySmall),
                  if (taxesLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(taxesLabel, style: AppTextStyles.caption),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MoneyText(lineTotal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
