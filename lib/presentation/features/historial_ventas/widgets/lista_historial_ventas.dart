import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/sales_history_item.dart';
import '../../../../modules/sales/store/sales_history.store.dart';
import '../../../molecules/cuerpo_error_reintentar.dart';
import '../../../molecules/pie_cargar_mas.dart';
import '../../../molecules/item_lista_venta.dart';
import 'sheet_detalle_venta.dart';

/// Lista paginada del historial de ventas.
class ListaHistorialVentas extends StatelessWidget {
  const ListaHistorialVentas({
    super.key,
    this.selectedId,
    this.onSeleccionar,
  });

  final int? selectedId;
  final ValueChanged<SaleHistoryItem>? onSeleccionar;

  String? _branchId(BuildContext context) {
    final id = context.read<AuthController>().user?.sucursalId;
    return id == null ? null : '$id';
  }

  Future<void> _openDetail(BuildContext context, SaleHistoryItem item) {
    if (onSeleccionar != null) {
      onSeleccionar!(item);
      return Future.value();
    }
    return SheetDetalleVenta.show(context, saleId: item.id);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesHistoryStore>();
    final branchId = _branchId(context);

    if (store.isLoadingList && store.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (store.error != null && store.items.isEmpty) {
      return CuerpoErrorReintentar(
        message: store.error!,
        onRetry: () => store.load(branchId: branchId),
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

    final itemCount = store.items.length + (store.hasMore ? 1 : 0);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= store.items.length) {
          return PieCargarMas(
            isLoading: store.isLoadingMore,
            hasMore: store.hasMore,
            onLoadMore: () => store.loadMore(branchId: branchId),
          );
        }

        final item = store.items[index];
        return ItemListaVenta(
          item: item,
          selected: selectedId == item.id,
          onTap: () => _openDetail(context, item),
        );
      },
    );
  }
}

/// Alias legacy — usar [ListaHistorialVentas].
typedef SaleHistoryList = ListaHistorialVentas;
