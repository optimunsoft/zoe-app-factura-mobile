import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Tile con borde usado en listas (icono + cuerpo + trailing).
class MosaicoConBorde extends StatelessWidget {
  const MosaicoConBorde({
    super.key,
    required this.leading,
    required this.body,
    this.trailing,
    this.onTap,
    this.marginBottom = AppSpacing.sm,
    this.selected = false,
  });

  final Widget leading;
  final Widget body;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double marginBottom;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: Material(
        color: selected ? AppColors.primaryLight : AppColors.surface,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.mdAll,
              border: AppBorders.selectable(selected: selected),
            ),
            child: Row(
              children: [
                leading,
                const SizedBox(width: AppSpacing.md),
                Expanded(child: body),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [MosaicoConBorde].
typedef BorderedListTile = MosaicoConBorde;
