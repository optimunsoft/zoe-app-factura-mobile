import 'package:flutter/material.dart';

import '../../core/layout/ancho_vista.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/pos_controller.dart';
import '../../modules/products/domain/mappers/pos_product_mapper.dart';
import '../../modules/products/store/products.store.dart';
import '../molecules/tarjeta_producto.dart';
import '../features/catalogo_productos/widgets/sheet_detalle_producto.dart';

/// Grilla de productos del catálogo POS con estados de carga/error/vacío.
class GrillaProductos extends StatelessWidget {
  const GrillaProductos({
    super.key,
    required this.posCtrl,
    required this.store,
    required this.onRetry,
  });

  final PosController posCtrl;
  final ProductsStore store;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                store.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (store.items.isEmpty) {
      return Center(
        child: Text(
          'No hay productos',
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount =
            AnchoVista.columnasProducto(context, constraints.maxWidth);
        const crossSpacing = AppSpacing.md;
        const horizontalPad = AppSpacing.xxl;
        final spacingTotal = crossSpacing * (crossCount - 1);
        final cardWidth =
            (constraints.maxWidth - horizontalPad - spacingTotal) / crossCount;

        final cardHeight =
            (cardWidth / TarjetaProducto.imageAspectRatio) +
            TarjetaProducto.fixedBelowImageHeight;
        final aspectRatio = cardWidth / cardHeight;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: crossSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: store.items.length,
          itemBuilder: (context, index) {
            final apiProduct = store.items[index];
            final product = PosProductMapper.toPosProduct(apiProduct);
            final qty = posCtrl.quantityOf(product.id);
            return TarjetaProducto(
              product: product,
              quantity: qty,
              maxQuantity: posCtrl.maxQuantityFor(product),
              onTap: () => SheetDetalleProducto.show(
                context,
                product: apiProduct,
                onAdd: product.inStock
                    ? (priceOption) {
                        posCtrl.addProduct(
                          PosProductMapper.toPosProduct(
                            apiProduct,
                            priceOption: priceOption,
                          ),
                        );
                      }
                    : null,
              ),
              onAdd: () => posCtrl.addProduct(product),
              onQuantityChanged: (v) => posCtrl.setQuantity(product, v),
            );
          },
        );
      },
    );
  }
}
