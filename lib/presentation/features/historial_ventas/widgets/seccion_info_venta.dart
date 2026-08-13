import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
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
    final notes = sale.notes?.trim() ?? '';
    final purchaseOrder = sale.purchaseOrder?.trim() ?? '';
    final dueDate = SalesHistoryMapper.formatLongDate(sale.dueDate);
    final paymentForm =
        sale.paymentForm.isNotEmpty ? sale.paymentForm : '—';

    final infoRows = <Widget>[
      DetailInfoRow(
        icon: Icons.storefront_outlined,
        label: 'Sucursal',
        value: sale.branchName.isNotEmpty ? sale.branchName : '—',
        iconInCircle: true,
        showDivider: true,
      ),
      DetailInfoRow(
        icon: Icons.badge_outlined,
        label: 'NIT / Documento',
        value: sale.thirdPartyNit.isNotEmpty ? sale.thirdPartyNit : '—',
        iconInCircle: true,
        showDivider: true,
      ),
      DetailInfoRow(
        icon: Icons.event_available_outlined,
        label: 'Fecha de vencimiento',
        value: dueDate,
        iconInCircle: true,
        showDivider: true,
      ),
      DetailInfoRow(
        icon: Icons.payments_outlined,
        label: 'Forma de pago',
        value: paymentForm,
        iconInCircle: true,
        valueWidget: AppBadge(
          label: paymentForm,
          background: AppColors.primaryLight,
          foreground: AppColors.primaryDark,
        ),
        showDivider: notes.isNotEmpty || purchaseOrder.isNotEmpty,
      ),
      if (notes.isNotEmpty)
        DetailInfoRow(
          icon: Icons.notes_outlined,
          label: 'Observaciones',
          value: notes,
          iconInCircle: true,
          showDivider: purchaseOrder.isNotEmpty,
        ),
      if (purchaseOrder.isNotEmpty)
        DetailInfoRow(
          icon: Icons.shopping_bag_outlined,
          label: 'Orden de compra',
          value: purchaseOrder,
          iconInCircle: true,
        ),
    ];

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
            borderRadius: AppRadius.mdAll,
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
        const SizedBox(height: AppSpacing.lg),
        Text('Información', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: infoRows,
          ),
        ),
      ],
    );
  }
}
