import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../modules/sales/domain/models/list_sales.models.dart';
import '../../modules/sales/store/sales.store.dart';
import '../atoms/app_button.dart';
import '../atoms/money_text.dart';
import 'sale_detail_sheet.dart';

/// Lista de ventas desde [SalesStore] (`GET /ventas/listar`).
/// Al tocar una tarjeta abre el detalle en slide-over.
/// El botón "Cargar más" siempre va después del último registro.
class TransactionList extends StatefulWidget {
  const TransactionList({
    super.key,
    this.query,
    this.autoLoad = true,
  });

  /// Query del listado. Por defecto `page=1`, `amount=10`.
  final ListSalesQuery? query;

  /// Si es `true`, carga el listado al montar el widget.
  final bool autoLoad;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  static final _timeFmt = DateFormat('HH:mm');
  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.autoLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) => reload());
    }
  }

  Future<void> reload() {
    return context.read<SalesStore>().loadListSales(
          query: widget.query ?? ListSalesQuery(),
        );
  }

  Future<void> _loadMore() {
    return context.read<SalesStore>().loadMoreListSales();
  }

  Future<void> _openDetail(ListSales sale) {
    return SaleDetailSheet.show(
      context,
      saleId: sale.id,
      preview: sale,
    );
  }

  String _subtitle(ListSales sale) {
    final parsed = DateTime.tryParse(sale.saleDate)?.toLocal();
    final timePart = parsed != null ? _timeFmt.format(parsed) : '';
    final datePart = parsed != null ? _dateFmt.format(parsed) : '';
    final payment = sale.paymentForm.isNotEmpty
        ? sale.paymentForm
        : (sale.paymentDetails.isNotEmpty
            ? sale.paymentDetails.map((p) => p.name).join(' + ')
            : '');

    final parts = <String>[
      if (datePart.isNotEmpty) datePart,
      if (timePart.isNotEmpty) timePart,
      if (payment.isNotEmpty) payment,
    ];
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesStore>();

    if (store.isLoadingList && store.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (store.error != null && store.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              store.error!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: reload,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (store.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No hay ventas registradas',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...store.items.map((sale) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _openDetail(sale),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.receipt_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sale.documentNumber.isNotEmpty
                                  ? sale.documentNumber
                                  : 'Venta #${sale.id}',
                              style: AppTextStyles.label,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sale.thirdPartyName.isNotEmpty
                                  ? sale.thirdPartyName
                                  : _subtitle(sale),
                              style: AppTextStyles.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _subtitle(sale),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      MoneyText(sale.saleTotalValue),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        if (store.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          AppButton(
            label: 'Cargar más',
            icon: Icons.expand_more_rounded,
            onPressed: _loadMore,
          ),
      ],
    );
  }
}
