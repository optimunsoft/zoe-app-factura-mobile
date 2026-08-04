import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/product.dart';
import '../atoms/app_badge.dart';
import '../atoms/money_text.dart';
import '../atoms/quantity_stepper.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onQuantityChanged,
  });

  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final disabled = !product.inStock;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(product.emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 10),
          AppBadge.stock(stock: product.stock),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(height: 1.25),
          ),
          const SizedBox(height: 6),
          MoneyText(product.price, large: true, color: AppColors.textPrimary),
          const Spacer(),
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
                max: product.stock,
                onChanged: onQuantityChanged,
              ),
            ),
        ],
      ),
    );
  }
}
