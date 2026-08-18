import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/ingresos_medios_pago.models.dart';
import '../../../atoms/money_text.dart';

/// Fila de una venta dentro de la previsualización del reporte.
class LineaIngresoVenta extends StatelessWidget {
  const LineaIngresoVenta({super.key, required this.item});

  final IngresoMedioPagoItem item;

  static final _dateFmt = DateFormat('dd/MM/yyyy HH:mm');

  String get _fechaLabel {
    final parsed = DateTime.tryParse(item.saleDate);
    if (parsed == null) return item.saleDate;
    return _dateFmt.format(parsed.toLocal());
  }

  double get _totalLineas {
    return item.paymentDetails.fold<double>(0, (sum, p) => sum + p.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.documentNumber.isEmpty ? 'Sin documento' : item.documentNumber,
                  style: AppTextStyles.label,
                ),
              ),
              Text(item.paymentForm, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            item.thirdPartyName,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(_fechaLabel, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm),
          if (item.paymentDetails.isEmpty)
            Text('Sin desglose de medios', style: AppTextStyles.caption)
          else ...[
            ...item.paymentDetails.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(p.name, style: AppTextStyles.bodySmall),
                    ),
                    MoneyText(p.amount, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text('Total medios', style: AppTextStyles.label),
                ),
                MoneyText(_totalLineas),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
