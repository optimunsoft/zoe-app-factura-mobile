import 'package:flutter/material.dart';
import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expanded = true,
    this.height = 52,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expanded;
  final double height;

  /// Padding y tipografía más pequeños (p. ej. «Limpiar» en filtros).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final bg = switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.surface,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.danger => AppColors.danger,
    };
    final fg = switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => AppColors.textPrimary,
      AppButtonVariant.ghost => AppColors.primary,
      AppButtonVariant.danger => Colors.white,
    };
    final border = switch (variant) {
      AppButtonVariant.secondary => Border.all(
          color: AppColors.borderStrong,
          width: AppBorders.thin,
        ),
      AppButtonVariant.ghost => Border.all(
          color: AppColors.primary,
          width: AppBorders.thin,
        ),
      _ => null,
    };

    final labelWidget = Text(
      label,
      textAlign: TextAlign.center,
      style: (compact ? AppTextStyles.caption : AppTextStyles.button).copyWith(
        color: enabled ? fg : AppColors.textMuted,
        fontWeight: FontWeight.w600,
      ),
    );

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: compact ? 16 : 20,
            color: enabled ? fg : AppColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        // Flexible solo con expanded: si no, Wrap lo estira a todo el ancho.
        if (expanded) Flexible(child: labelWidget) else labelWidget,
      ],
    );

    final radius = compact ? AppRadius.smAll : AppRadius.mdAll;

    final button = Material(
      color: enabled ? bg : AppColors.surfaceAlt,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Container(
          // Con alignment el Container se estira al max width (p. ej. en Wrap).
          alignment: expanded ? Alignment.center : null,
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.md : AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: border,
          ),
          child: child,
        ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }

    // Fuerza ancho al contenido; evita que Wrap lo estire a toda la línea.
    return IntrinsicWidth(child: button);
  }
}
