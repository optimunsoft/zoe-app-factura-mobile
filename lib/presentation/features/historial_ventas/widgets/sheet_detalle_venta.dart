import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/list_sales.models.dart';
import '../../../../modules/sales/store/sales_history.store.dart';
import '../../../molecules/cuerpo_error_reintentar.dart';
import '../../../organisms/sheet_inferior_app.dart';
import 'linea_producto_venta.dart';
import 'boton_descargar_pdf_venta.dart';
import 'seccion_medios_pago_venta.dart';
import 'seccion_info_venta.dart';

/// Slide-over con el detalle completo de una venta.
class SheetDetalleVenta extends StatefulWidget {
  const SheetDetalleVenta({
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
    return SheetInferiorApp.show<void>(
      context,
      child: SheetDetalleVenta(saleId: saleId, preview: preview),
    );
  }

  @override
  State<SheetDetalleVenta> createState() => _SheetDetalleVentaState();
}

class _SheetDetalleVentaState extends State<SheetDetalleVenta> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalesHistoryStore>().loadDetail(widget.saleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesHistoryStore>();
    final sale = store.detailFor(widget.saleId) ?? widget.preview;
    final detailError = store.detailErrorFor(widget.saleId);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return store.isLoadingDetail && sale == null
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          : sale == null
              ? CuerpoErrorReintentar(
                  message: detailError ?? 'No se pudo cargar la venta',
                  onRetry: () =>
                      context.read<SalesHistoryStore>().loadDetail(widget.saleId),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg + bottom,
                  ),
                  child: CuerpoDetalleVenta(
                    sale: sale,
                    isRefreshing: store.isLoadingDetail,
                  ),
                );
  }
}

class CuerpoDetalleVenta extends StatelessWidget {
  const CuerpoDetalleVenta({
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
        SeccionInfoVenta(sale: sale, isRefreshing: isRefreshing),
        const SizedBox(height: AppSpacing.lg),
        SeccionMediosPagoVenta(sale: sale),
        const SizedBox(height: AppSpacing.lg),
        Text('Productos', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.sm),
        if (sale.details.isEmpty)
          Text('Sin productos', style: AppTextStyles.bodySmall)
        else
          ...sale.details.map((d) => LineaProductoVenta(detail: d)),
        if (sale.documentNumber.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          BotonDescargarPdfVenta(nroDocumento: sale.documentNumber),
        ],
      ],
    );
  }
}

/// Alias legacy — usar [SheetDetalleVenta].
typedef SaleDetailSheet = SheetDetalleVenta;

