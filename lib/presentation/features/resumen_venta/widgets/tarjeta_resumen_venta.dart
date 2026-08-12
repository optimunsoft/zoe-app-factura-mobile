import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/product.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../atoms/money_text.dart';
import '../../../molecules/panel_retenciones.dart';
import 'fila_resumen.dart';

/// Resumen de compra al estilo del checkout (detalle + retenciones + total).
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen de la compra', style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(
                    'Revisa el detalle de tu compra y continúa',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilaResumen(label: 'Subtotal', value: subtotal, large: true),
                  if (taxBreakdown.isEmpty)
                    const FilaResumen(label: 'Impuestos', value: 0, large: true)
                  else
                    ...taxBreakdown.map(
                      (t) => FilaResumen(
                        label: t.label,
                        value: t.amount,
                        large: true,
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: AppColors.border),
                  ),
                  FilaResumen(
                    label: 'Total bruto',
                    value: total,
                    emphasize: true,
                  ),
                  const SizedBox(height: 12),
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
                  if (fillHeight) const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total a pagar',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                MoneyText(
                  payableTotal,
                  xl: true,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [TarjetaResumenVenta].
typedef CheckoutSummaryCard = TarjetaResumenVenta;
