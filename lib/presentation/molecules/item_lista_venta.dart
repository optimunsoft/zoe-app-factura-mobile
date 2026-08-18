import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/sales/domain/models/sales_history_item.dart';
import '../atoms/money_text.dart';
import 'mosaico_con_borde.dart';

/// Fila de una venta en el historial.
class ItemListaVenta extends StatelessWidget {
  const ItemListaVenta({
    super.key,
    required this.item,
    required this.onTap,
  });

  final SaleHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MosaicoConBorde(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: AppRadius.smAll,
        ),
        child: Icon(Icons.receipt_rounded, color: AppColors.primary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.documentLabel, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            item.customerName,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(item.subtitle, style: AppTextStyles.caption),
        ],
      ),
      trailing: MoneyText(item.total),
    );
  }
}

/// Alias legacy — usar [ItemListaVenta].
typedef SaleListItem = ItemListaVenta;
