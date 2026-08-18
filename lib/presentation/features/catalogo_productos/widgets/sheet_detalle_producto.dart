import 'package:flutter/material.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/products/domain/models/products.models.dart';
import '../../../atoms/app_badge.dart';
import '../../../atoms/detail_info_row.dart';
import '../../../atoms/product_image_placeholder.dart';
import '../../../molecules/lista_impuestos_producto.dart';
import '../../../molecules/selector_precio_venta.dart';
import '../../../organisms/sheet_inferior_app.dart';

/// Slide-over con el detalle completo del producto.
class SheetDetalleProducto extends StatefulWidget {
  const SheetDetalleProducto({
    super.key,
    required this.product,
    this.onAdd,
  });

  final Product product;
  final ValueChanged<SellingPriceOption>? onAdd;

  static Future<void> show(
    BuildContext context, {
    required Product product,
    ValueChanged<SellingPriceOption>? onAdd,
  }) {
    return SheetInferiorApp.show<void>(
      context,
      child: SheetDetalleProducto(product: product, onAdd: onAdd),
    );
  }

  @override
  State<SheetDetalleProducto> createState() => _SheetDetalleProductoState();
}

class _SheetDetalleProductoState extends State<SheetDetalleProducto> {
  late SellingPriceOption _selectedPrice;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    final options = product.sellingPrices.options;
    _selectedPrice = options.isNotEmpty
        ? options.first
        : const SellingPriceOption(key: 'default', label: 'General', price: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final priceOptions = product.sellingPrices.options;
    final canAdd = widget.onAdd != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AspectRatio(
                  aspectRatio: 1.6,
                  child: ProductImagePlaceholder(),
                ),
                const SizedBox(height: 16),
                Text(product.name, style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppBadge.stock(
                      stock: product.quantity,
                      fontSize: 15,
                    ),
                    if (product.category.name.isNotEmpty)
                      AppBadge(
                        label: product.category.name,
                        background: AppColors.primaryLight,
                        foreground: AppColors.primaryDark,
                        fontSize: 15,
                      ),
                    if (product.productTaxType.isNotEmpty)
                      AppBadge(
                        label: product.productTaxType,
                        background: AppColors.surfaceAlt,
                        foreground: AppColors.textSecondary,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Precio de compra', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                SelectorPrecioVenta(
                  options: priceOptions,
                  selected: _selectedPrice,
                  onSelected: (option) =>
                      setState(() => _selectedPrice = option),
                ),
                const SizedBox(height: 12),
                Text('Información', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                DetailInfoRow(
                  icon: Icons.tag_outlined,
                  label: 'ID',
                  value: '${product.id}',
                ),
                DetailInfoRow(
                  icon: Icons.qr_code_2_outlined,
                  label: 'Código de barras',
                  value: product.barcode.isEmpty ? '—' : product.barcode,
                ),
                DetailInfoRow(
                  icon: Icons.bookmark_border_rounded,
                  label: 'Referencia',
                  value: (product.reference == null ||
                          product.reference!.isEmpty)
                      ? '—'
                      : product.reference!,
                ),
                DetailInfoRow(
                  icon: Icons.category_outlined,
                  label: 'Categoría',
                  value: product.category.name.isEmpty
                      ? '—'
                      : product.category.name,
                ),
                DetailInfoRow(
                  icon: Icons.store_outlined,
                  label: 'Sucursal',
                  value: product.branch.name.isEmpty
                      ? '—'
                      : product.branch.name,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cantidad', style: AppTextStyles.caption),
                            Text(
                              '${product.quantity}',
                              style: AppTextStyles.h2.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (product.taxes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ListaImpuestosProducto(taxes: product.taxes),
                ],
              ],
            ),
          ),
        ),
        if (canAdd)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottom),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: AppBorders.top,
              boxShadow: AppShadows.bar,
            ),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: product.inStock
                    ? () {
                        widget.onAdd!(_selectedPrice);
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.surfaceAlt,
                ),
                child: Text(
                  product.inStock ? '+ Agregar al carrito' : 'Agotado',
                  style: AppTextStyles.button.copyWith(
                    color: product.inStock
                        ? Colors.white
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Alias legacy — usar [SheetDetalleProducto].
typedef ProductDetailSheet = SheetDetalleProducto;
