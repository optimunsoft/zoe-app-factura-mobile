import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/product.dart';
import '../../../atoms/app_badge.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/product_image_placeholder.dart';
import '../../../atoms/quantity_stepper.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onQuantityChanged,
    this.onTap,
    this.maxQuantity,
  });

  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback? onTap;

  /// Tope de esta línea (stock compartido entre precios). Por defecto [product.stock].
  final int? maxQuantity;

  static final TextStyle _nameStyle =
      AppTextStyles.label.copyWith(height: 1.25);

  static double get _nameLineHeight =>
      (_nameStyle.fontSize ?? 13) * (_nameStyle.height ?? 1.25);

  /// Si el nombre cabe en una línea, fuerza salto para ocupar dos renglones.
  static String _twoLineName(String name, double maxWidth) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;

    final oneLine = TextPainter(
      text: TextSpan(text: trimmed, style: _nameStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    if (oneLine.didExceedMaxLines) return trimmed;

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final mid = (parts.length / 2).ceil();
      return '${parts.sublist(0, mid).join(' ')}\n${parts.sublist(mid).join(' ')}';
    }

    return '$trimmed\n';
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !product.inStock;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solo esta zona abre el detalle; el botón/stepper queda fuera.
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AspectRatio(
                        aspectRatio: 1.55,
                        child: ProductImagePlaceholder(),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBadge.stock(stock: product.stock),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: _nameLineHeight * 2,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Text(
                                    _twoLineName(
                                      product.name,
                                      constraints.maxWidth,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: _nameStyle,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            MoneyText(
                              product.price,
                              color: AppColors.textPrimary,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (quantity == 0)
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: disabled ? null : onAdd,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.surfaceAlt,
                  ),
                  child: Text(
                    '+ Agregar',
                    style: AppTextStyles.button.copyWith(
                      color: disabled ? AppColors.textMuted : Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            else
              Align(
                alignment: Alignment.center,
                child: QuantityStepper(
                  value: quantity,
                  max: maxQuantity ?? product.stock,
                  onChanged: onQuantityChanged,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
