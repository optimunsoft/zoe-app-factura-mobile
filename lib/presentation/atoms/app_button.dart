import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
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
      AppButtonVariant.secondary => Border.all(color: AppColors.borderStrong),
      AppButtonVariant.ghost => Border.all(color: AppColors.primary),
      _ => null,
    };

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
          SizedBox(width: compact ? 6 : 8),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: (compact ? AppTextStyles.caption : AppTextStyles.button)
                .copyWith(
              color: enabled ? fg : AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    final radius = compact ? 8.0 : 12.0;

    return SizedBox(
      width: expanded ? double.infinity : null,
      height: height,
      child: Material(
        color: enabled ? bg : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
