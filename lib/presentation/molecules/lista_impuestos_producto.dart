import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../modules/products/domain/models/products.models.dart';

/// Lista de impuestos aplicables a un producto.
class ListaImpuestosProducto extends StatelessWidget {
  const ListaImpuestosProducto({
    super.key,
    required this.taxes,
  });

  final List<ProductTax> taxes;

  @override
  Widget build(BuildContext context) {
    if (taxes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Impuestos', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.sm),
        ...taxes.map(
          (t) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: AppRadius.mdAll,
              border: AppBorders.subtle,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.name, style: AppTextStyles.label),
                      const SizedBox(height: AppSpacing.xxs),
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
    );
  }
}
