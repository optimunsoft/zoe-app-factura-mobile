import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_format.dart';
import '../../modules/sales/domain/models/list_sales.models.dart';
import '../../modules/sales/store/sales.store.dart';
import '../atoms/app_badge.dart';
import '../atoms/detail_info_row.dart';
import '../atoms/money_text.dart';
import '../atoms/product_image_placeholder.dart';

/// Slide-over con el detalle completo de una venta.
class SaleDetailSheet extends StatefulWidget {
  const SaleDetailSheet({
    super.key,
    required this.saleId,
    this.preview,
  });

  final int saleId;
  final ListSales? preview;

  static Future<void> show(
    BuildContext context, {
    required int saleId,
    ListSales? preview,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaleDetailSheet(
        saleId: saleId,
        preview: preview,
      ),
    );
  }

  @override
  State<SaleDetailSheet> createState() => _SaleDetailSheetState();
}

class _SaleDetailSheetState extends State<SaleDetailSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalesStore>().loadSaleById(widget.saleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesStore>();
    final sale = store.selected?.id == widget.saleId
        ? store.selected
        : widget.preview;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Flexible(
              child: store.isLoadingDetail && sale == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : sale == null
                      ? _ErrorBody(
                          message: store.error ?? 'No se pudo cargar la venta',
                          onRetry: () =>
                              context.read<SalesStore>().loadSaleById(
                                    widget.saleId,
                                  ),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottom),
                          child: _SaleDetailBody(
                            sale: sale,
                            isRefreshing: store.isLoadingDetail,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleDetailBody extends StatelessWidget {
  const _SaleDetailBody({
    required this.sale,
    required this.isRefreshing,
  });

  final ListSales sale;
  final bool isRefreshing;

  static final _dateFmt = DateFormat('dd/MM/yyyy HH:mm');

  String _formatDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.isEmpty ? '—' : raw;
    return _dateFmt.format(parsed.toLocal());
  }

  /// Primera letra en mayúscula, resto en minúscula (por palabra).
  String _toTitleCase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          final lower = word.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }

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
              ? _toTitleCase(sale.thirdPartyName)
              : 'Sin cliente',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 8),
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
          value: _formatDate(sale.saleDate),
        ),
        DetailInfoRow(
          icon: Icons.event_available_outlined,
          label: 'Fecha de vencimiento',
          value: _formatDate(sale.dueDate),
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
        const SizedBox(height: 18),
        Text('Medios de pago', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        if (sale.paymentDetails.isEmpty)
          Text('Sin detalle de pago', style: AppTextStyles.bodySmall)
        else
          ...sale.paymentDetails.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
        const SizedBox(height: 18),
        Text('Productos', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        if (sale.details.isEmpty)
          Text('Sin productos', style: AppTextStyles.bodySmall)
        else
          ...sale.details.map((d) {
            final taxesLabel = d.taxes.isEmpty
                ? null
                : d.taxes
                    .map((t) => '${t.name} ${t.percentage}%')
                    .join(' · ');
            final lineTotal = (d.quantity * d.unitPrice) - d.discount;
            final qtyPrice =
                '${d.quantity} × ${CurrencyFormat.money(d.unitPrice)}'
                '${d.discount > 0 ? ' · Desc. ${CurrencyFormat.money(d.discount)}' : ''}';

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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name, style: AppTextStyles.label),
                          const SizedBox(height: 6),
                          Text(qtyPrice, style: AppTextStyles.bodySmall),
                          if (taxesLabel != null) ...[
                            const SizedBox(height: 4),
                            Text(taxesLabel, style: AppTextStyles.caption),
                          ],
                          const SizedBox(height: 8),
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
          }),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
