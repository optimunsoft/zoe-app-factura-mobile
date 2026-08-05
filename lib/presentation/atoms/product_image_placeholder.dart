import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder genérico cuando el producto no trae imagen.
class ProductImagePlaceholder extends StatelessWidget {
  const ProductImagePlaceholder({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 28.0 : 44.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.inventory_2_outlined,
        size: iconSize,
        color: AppColors.borderStrong.withValues(alpha: 0.55),
      ),
    );
  }
}
