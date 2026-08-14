import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/status_dot.dart';

class InsigniaEstadoImpresora extends StatelessWidget {
  const InsigniaEstadoImpresora({
    super.key,
    required this.connected,
    this.mode = 'Bluetooth',
    this.onTap,
  });

  final bool connected;
  final String mode;
  final VoidCallback? onTap;

  String _shortMode(String mode) {
    final lower = mode.toLowerCase();
    if (lower.contains('bluetooth')) return 'BT';
    if (lower.contains('wifi') || lower.contains('wi-fi')) return 'WiFi';
    if (lower.contains('usb')) return 'USB';
    return mode;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: connected ? AppColors.successBg : AppColors.dangerBg,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusDot(active: connected),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.print_rounded,
                size: 14,
                color: connected ? AppColors.success : AppColors.danger,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                connected ? _shortMode(mode) : 'Off',
                style: AppTextStyles.caption.copyWith(
                  color: connected ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [InsigniaEstadoImpresora].
typedef PrinterStatusBadge = InsigniaEstadoImpresora;
