import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/cart_item.dart';
import '../../../atoms/icon_action_button.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/product_image_placeholder.dart';
import '../../../atoms/quantity_stepper.dart';

class CartLineItem extends StatelessWidget {
  const CartLineItem({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                Text(item.product.name, style: AppTextStyles.label),
                const SizedBox(height: 2),
                MoneyText(item.product.price, color: AppColors.textSecondary),
                const SizedBox(height: 10),
                QuantityStepper(
                  value: item.quantity,
                  min: 1,
                  max: item.product.stock,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconActionButton(
                icon: Icons.delete_outline_rounded,
                color: AppColors.danger,
                backgroundColor: AppColors.dangerBg,
                tooltip: 'Eliminar',
                onPressed: onRemove,
              ),
              const SizedBox(height: 12),
              MoneyText(item.lineTotal, large: true),
            ],
          ),
        ],
      ),
    );
  }
}
