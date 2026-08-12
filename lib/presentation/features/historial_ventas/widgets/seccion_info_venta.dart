import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/mappers/sales_history_mapper.dart';
import '../../../../modules/sales/domain/models/list_sales.models.dart';
import '../../../atoms/app_badge.dart';
import '../../../atoms/detail_info_row.dart';
import '../../../atoms/money_text.dart';

/// Documento, tercero, total e información general de la venta.
class SeccionInfoVenta extends StatelessWidget {
  const SeccionInfoVenta({
    super.key,
    required this.sale,
    required this.isRefreshing,
  });

  final ListSales sale;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nro de Documento:', style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  AppBadge(
                    label: sale.documentNumber.isNotEmpty
                        ? sale.documentNumber
                        : 'Venta #${sale.id}',
                    background: AppColors.primaryLight,
                    foreground: AppColors.primary,
                    fontSize: 15,
                  ),
                ],
              ),
            ),
            if (isRefreshing)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Tercero:', style: AppTextStyles.h3),
        const SizedBox(height: 4),
        Text(
          sale.thirdPartyName.isNotEmpty
              ? SalesHistoryMapper.toTitleCase(sale.thirdPartyName)
              : 'Sin cliente',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text('Total venta', style: AppTextStyles.label),
              ),
              MoneyText(sale.saleTotalValue, large: true),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('Información', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.sm),
        DetailInfoRow(
          icon: Icons.storefront_outlined,
          label: 'Sucursal',
          value: sale.branchName.isNotEmpty ? sale.branchName : '—',
        ),
        DetailInfoRow(
          icon: Icons.badge_outlined,
          label: 'NIT / Documento',
          value: sale.thirdPartyNit.isNotEmpty ? sale.thirdPartyNit : '—',
        ),
        DetailInfoRow(
          icon: Icons.event_outlined,
          label: 'Fecha de venta',
          value: SalesHistoryMapper.formatDateTime(sale.saleDate),
        ),
        DetailInfoRow(
          icon: Icons.event_available_outlined,
          label: 'Fecha de vencimiento',
          value: SalesHistoryMapper.formatDateTime(sale.dueDate),
        ),
        DetailInfoRow(
          icon: Icons.payments_outlined,
          label: 'Forma de pago',
          value: sale.paymentForm.isNotEmpty ? sale.paymentForm : '—',
        ),
        if (sale.notes != null && sale.notes!.trim().isNotEmpty)
          DetailInfoRow(
            icon: Icons.notes_outlined,
            label: 'Observaciones',
            value: sale.notes!,
          ),
        if (sale.purchaseOrder != null &&
            sale.purchaseOrder!.trim().isNotEmpty)
          DetailInfoRow(
            icon: Icons.shopping_bag_outlined,
            label: 'Orden de compra',
            value: sale.purchaseOrder!,
          ),
      ],
    );
  }
}
