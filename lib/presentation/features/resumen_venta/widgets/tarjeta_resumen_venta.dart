import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/models/product.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../molecules/panel_retenciones.dart';
import 'bloque_desglose_montos.dart';

/// Composición legacy del resumen (desglose + retenciones).
/// Preferir ensamblar los bloques desde [ResumenVentaPage].
class TarjetaResumenVenta extends StatelessWidget {
  const TarjetaResumenVenta({
    super.key,
    required this.subtotal,
    required this.taxBreakdown,
    required this.total,
    required this.payableTotal,
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
    this.fillHeight = false,
  });

  final double subtotal;
  final List<TaxBreakdownLine> taxBreakdown;
  final double total;

  /// Conservado por compatibilidad; el total a pagar vive en [PieTotalPagar].
  final double payableTotal;

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
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BloqueDesgloseMontos(
          subtotal: subtotal,
          taxBreakdown: taxBreakdown,
          total: total,
        ),
        const SizedBox(height: AppSpacing.md),
        PanelRetenciones(
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
      ],
    );

    if (!fillHeight) return content;

    return SingleChildScrollView(child: content);
  }
}

/// Alias legacy — usar [TarjetaResumenVenta] o los bloques del feature.
typedef CheckoutSummaryCard = TarjetaResumenVenta;
