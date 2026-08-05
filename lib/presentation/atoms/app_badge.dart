import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.background = AppColors.primaryLight,
    this.foreground = AppColors.primaryDark,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  factory AppBadge.stock({required int stock}) {
    if (stock <= 0) {
      return const AppBadge(
        label: 'Agotado',
        background: AppColors.dangerBg,
        foreground: AppColors.danger,
      );
    }
    if (stock <= 8) {
      return AppBadge(
        label: 'Cantidad $stock',
        background: AppColors.warningBg,
        foreground: AppColors.warning,
      );
    }
    return AppBadge(
      label: 'Cantidad $stock',
      background: AppColors.successBg,
      foreground: AppColors.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
