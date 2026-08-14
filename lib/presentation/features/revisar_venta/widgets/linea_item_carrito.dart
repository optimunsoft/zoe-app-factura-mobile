import 'package:flutter/material.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/cart_item.dart';
import '../../../atoms/icon_action_button.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/product_image_placeholder.dart';
import '../../../atoms/quantity_stepper.dart';

class LineaItemCarrito extends StatelessWidget {
  const LineaItemCarrito({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    this.maxQuantity,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final int? maxQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: ProductImagePlaceholder(compact: true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: AppTextStyles.label,
                      softWrap: true,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    MoneyText(
                      item.product.price,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconActionButton(
                icon: Icons.delete_outline_rounded,
                color: AppColors.danger,
                backgroundColor: AppColors.dangerBg,
                tooltip: 'Eliminar',
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: QuantityStepper(
                    value: item.quantity,
                    min: 1,
                    max: maxQuantity ?? item.product.stock,
                    onChanged: onQuantityChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MoneyText(item.lineTotal, large: true),
            ],
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [LineaItemCarrito].
typedef CartLineItem = LineaItemCarrito;
