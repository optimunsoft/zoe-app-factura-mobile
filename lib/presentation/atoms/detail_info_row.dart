import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Fila de detalle clave/valor (ficha cliente, producto, venta).
class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueWidget,
    this.showDivider = false,
    this.iconInCircle = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Si se define, reemplaza el texto del valor (p. ej. un [AppBadge]).
  final Widget? valueWidget;

  /// Separador inferior (útil dentro de una card).
  final bool showDivider;

  /// Icono dentro de círculo primaryLight.
  final bool iconInCircle;

  @override
  Widget build(BuildContext context) {
    final iconWidget = iconInCircle
        ? Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          )
        : Icon(icon, size: 16, color: AppColors.primary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: iconInCircle ? AppSpacing.sm : 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconWidget,
              SizedBox(width: iconInCircle ? AppSpacing.md : 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: iconInCircle
                          ? AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            )
                          : AppTextStyles.caption,
                    ),
                    const SizedBox(height: 2),
                    valueWidget ??
                        Text(
                          value,
                          style: iconInCircle
                              ? AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                )
                              : AppTextStyles.body,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.border),
      ],
    );
  }
}
