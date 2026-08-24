import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Fila de una sección del drawer (normal / seleccionado / presionado).
class ItemDrawerNavegacion extends StatelessWidget {
  const ItemDrawerNavegacion({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.selectedIcon,
    this.selected = false,
    this.danger = false,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final bool selected;
  final bool danger;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Color fg;
    if (danger) {
      fg = AppColors.danger;
    } else if (selected) {
      fg = AppColors.textoSeleccionado;
    } else {
      fg = AppColors.textPrimary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(
                alpha: AppColors.oscuro ? 0.22 : 0.1,
              )
            : Colors.transparent,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  selected ? (selectedIcon ?? icon) : icon,
                  color: fg,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.label.copyWith(
                      color: fg,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
