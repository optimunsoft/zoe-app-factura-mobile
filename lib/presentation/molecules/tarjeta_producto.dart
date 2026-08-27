import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/product.dart';
import '../atoms/money_text.dart';
import '../atoms/product_image_placeholder.dart';
import '../atoms/quantity_stepper.dart';

/// Tarjeta de producto en la grilla del catálogo POS.
class TarjetaProducto extends StatelessWidget {
  const TarjetaProducto({
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

  /// Relación ancho/alto del bloque de imagen.
  static const imageAspectRatio = 1.15;

  /// Altura fija del contenido bajo la imagen (padding + textos + precio + CTA).
  static const fixedBelowImageHeight = 196.0;

  static const double _nameFontSize = 14;
  static const double _nameLineHeight = 1.25;

  static TextStyle get _nameStyle => AppTextStyles.label.copyWith(
        fontSize: _nameFontSize,
        fontWeight: FontWeight.w700,
        height: _nameLineHeight,
        color: AppColors.oscuro ? Colors.white : AppColors.textPrimary,
      );

  /// Altura fija de 2 renglones (directriz original).
  static double get _nameBlockHeight =>
      _nameFontSize * _nameLineHeight * 2;

  /// Si cabe en 1 línea, fuerza 2 renglones; si es largo, wrap natural (máx. 2 + …).
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

  Color get _stockFg {
    if (product.stock <= 0) return AppColors.danger;
    if (product.stock <= 8) return AppColors.warning;
    return AppColors.success;
  }

  Color get _stockBg {
    if (product.stock <= 0) return AppColors.dangerBg;
    if (product.stock <= 8) return AppColors.warningBg;
    return AppColors.successBg;
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !product.inStock;
    final maxQty = maxQuantity ?? product.stock;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: AppBorders.subtle,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AspectRatio(
                  aspectRatio: imageAspectRatio,
                  child: ProductImagePlaceholder(),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: _nameBlockHeight,
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Text(
                        _twoLineName(product.name, constraints.maxWidth),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _nameStyle,
                      );
                    },
                  ),
                ),
                if (product.code.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Código: ${product.code}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _stockBg,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(
                      product.stock <= 0
                          ? 'Agotado'
                          : 'Cantidad: ${product.stock}',
                      style: AppTextStyles.label.copyWith(
                        color: _stockFg,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: MoneyText(
                    product.price,
                    color: AppColors.textPrimary,
                    hideZeroDecimals: true,
                    style: AppTextStyles.money.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 42,
            child: quantity == 0
                ? ElevatedButton(
                    onPressed: disabled ? null : onAdd,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.surfaceAlt,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdAll,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      '+ Agregar',
                      style: AppTextStyles.button.copyWith(
                        color: disabled ? AppColors.textMuted : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Center(
                    child: QuantityStepper(
                      value: quantity,
                      max: maxQty,
                      onChanged: onQuantityChanged,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Alias de compatibilidad con imports anteriores.
typedef ProductCard = TarjetaProducto;
