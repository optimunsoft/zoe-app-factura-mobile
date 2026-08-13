import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/app_badge.dart';

/// Contexto de la venta: cliente, cantidad de ítems y badges fiscales.
class EncabezadoContextoVenta extends StatelessWidget {
  const EncabezadoContextoVenta({
    super.key,
    required this.customerName,
    required this.itemCount,
    this.freeZone = false,
  });

  final String customerName;
  final int itemCount;
  final bool freeZone;

  @override
  Widget build(BuildContext context) {
    final itemsLabel =
        '$itemCount producto${itemCount == 1 ? '' : 's'}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customerName.isEmpty ? 'Sin cliente' : customerName,
            style: AppTextStyles.h3,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(itemsLabel, style: AppTextStyles.bodySmall),
              if (freeZone) ...[
                const SizedBox(width: AppSpacing.sm),
                AppBadge(
                  label: 'Zona franca',
                  icon: Icons.place_outlined,
                  background: AppColors.warningBg,
                  foreground: AppColors.warning,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
