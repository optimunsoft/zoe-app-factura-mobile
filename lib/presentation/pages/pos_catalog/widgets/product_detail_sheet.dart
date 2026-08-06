import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/products/domain/models/products.models.dart';
import '../../../atoms/app_badge.dart';
import '../../../atoms/detail_info_row.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/product_image_placeholder.dart';

/// Slide-over (bottom sheet) con el detalle completo del producto.
class ProductDetailSheet extends StatefulWidget {
  const ProductDetailSheet({
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
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailSheet(
        product: product,
        onAdd: onAdd,
      ),
    );
  }

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
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
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;
    final priceOptions = product.sellingPrices.options;
    final canAdd = widget.onAdd != null;

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
                    ...priceOptions.map((option) {
                      final selected = option.key == _selectedPrice.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: selected
                              ? AppColors.primaryLight
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedPrice = option),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      option.label,
                                      style: AppTextStyles.label,
                                    ),
                                  ),
                                  MoneyText(
                                    option.price,
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
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
                      Text('Impuestos', style: AppTextStyles.h3),
                      const SizedBox(height: 8),
                      ...product.taxes.map(
                        (t) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.name, style: AppTextStyles.label),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Código ${t.code}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${t.percentage}%',
                                style: AppTextStyles.label,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                  border: Border(
                    top: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
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
        ),
      ),
    );
  }
}
