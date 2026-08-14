import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Fila Desde/Hasta para selección de rango de fechas.
class FilaRangoFechas extends StatelessWidget {
  const FilaRangoFechas({
    super.key,
    required this.startLabel,
    required this.endLabel,
    required this.startValue,
    required this.endValue,
    required this.onPickStart,
    required this.onPickEnd,
    this.onClearStart,
    this.onClearEnd,
  });

  final String startLabel;
  final String endLabel;
  final String startValue;
  final String endValue;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback? onClearStart;
  final VoidCallback? onClearEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateTile(
            label: startLabel,
            value: startValue,
            onTap: onPickStart,
            onClear: onClearStart,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _DateTile(
            label: endLabel,
            value: endValue,
            onTap: onPickEnd,
            onClear: onClearEnd,
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: AppBorders.subtle,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(value, style: AppTextStyles.label),
                  ],
                ),
              ),
              if (onClear != null)
                IconButton(
                  tooltip: 'Quitar',
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppColors.textSecondary,
                )
              else
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [FilaRangoFechas].
typedef DateRangePickerRow = FilaRangoFechas;
