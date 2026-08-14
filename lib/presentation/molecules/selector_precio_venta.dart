import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../modules/products/domain/models/products.models.dart';
import '../atoms/money_text.dart';

/// Lista de opciones de precio de venta (radio buttons).
class SelectorPrecioVenta extends StatelessWidget {
  const SelectorPrecioVenta({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<SellingPriceOption> options;
  final SellingPriceOption selected;
  final ValueChanged<SellingPriceOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: options.map((option) {
        final isSelected = option.key == selected.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Material(
            color: isSelected ? AppColors.primaryLight : AppColors.surface,
            borderRadius: AppRadius.mdAll,
            child: InkWell(
              onTap: () => onSelected(option),
              borderRadius: AppRadius.mdAll,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: AppBorders.selectable(selected: isSelected),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textMuted,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(option.label, style: AppTextStyles.label),
                    ),
                    MoneyText(
                      option.price,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
