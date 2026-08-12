import 'package:flutter/material.dart';

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
    this.marginBottom = AppSpacing.sm + 2,
  });

  final Widget leading;
  final Widget body;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: AppColors.border),
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
