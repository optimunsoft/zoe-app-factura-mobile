import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.background,
    this.foreground,
    this.icon,
    this.fontSize,
  });

  final String label;
  final Color? background;
  final Color? foreground;
  final IconData? icon;
  final double? fontSize;

  factory AppBadge.stock({required int stock, double? fontSize}) {
    if (stock <= 0) {
      return AppBadge(
        label: 'Agotado',
        background: AppColors.dangerBg,
        foreground: AppColors.danger,
        fontSize: fontSize,
      );
    }
    if (stock <= 8) {
      return AppBadge(
        label: 'Cantidad: $stock',
        background: AppColors.warningBg,
        foreground: AppColors.warning,
        fontSize: fontSize,
      );
    }
    return AppBadge(
      label: 'Cantidad: $stock',
      background: AppColors.successBg,
      foreground: AppColors.success,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = fontSize ?? 11;
    final bg = background ?? AppColors.primaryLight;
    final fg = foreground ?? AppColors.textoSeleccionado;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize != null ? AppSpacing.md : AppSpacing.sm,
        vertical: fontSize != null ? AppSpacing.sm : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: size + 1, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: size,
            ),
          ),
        ],
      ),
    );
  }
}
