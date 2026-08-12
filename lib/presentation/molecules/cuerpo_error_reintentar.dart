import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../atoms/app_button.dart';

/// Estado de error con acción de reintentar.
class CuerpoErrorReintentar extends StatelessWidget {
  const CuerpoErrorReintentar({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Reintentar',
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(color: AppColors.danger),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: retryLabel,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

typedef ErrorRetryBody = CuerpoErrorReintentar;
