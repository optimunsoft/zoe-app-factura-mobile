import 'package:flutter/material.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class TarjetaAcceso extends StatelessWidget {
  const TarjetaAcceso({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.accent,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final acento = accent ?? AppColors.primary;
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: AppBorders.subtle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(icon, color: acento, size: 22),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [TarjetaAcceso].
typedef DashboardCard = TarjetaAcceso;
