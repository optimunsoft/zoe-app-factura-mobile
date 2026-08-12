import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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
        const SizedBox(height: 8),
        ...taxes.map(
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
    );
  }
}
