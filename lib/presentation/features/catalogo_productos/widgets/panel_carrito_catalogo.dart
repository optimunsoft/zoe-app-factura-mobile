import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/pos_controller.dart';
import '../../revisar_venta/widgets/lista_items_carrito.dart';
import 'barra_resumen_pedido.dart';

/// Carrito persistente en tablet / landscape: líneas + total.
class PanelCarritoCatalogo extends StatelessWidget {
  const PanelCarritoCatalogo({
    super.key,
    required this.onReviewPay,
  });

  final VoidCallback onReviewPay;

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();

    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Carrito', style: AppTextStyles.h3),
                ),
                Text(
                  '${pos.itemCount}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListaItemsCarrito(
              items: pos.cart,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              onQuantityChanged: (item, qty) {
                pos.setQuantity(item.product, qty);
              },
              onRemove: (item) => pos.removeItem(item.product),
            ),
          ),
          BarraResumenPedido(
            itemCount: pos.itemCount,
            total: pos.total,
            onReviewPay: onReviewPay,
          ),
        ],
      ),
    );
  }
}
