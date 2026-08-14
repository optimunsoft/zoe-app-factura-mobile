import 'package:flutter/material.dart';
import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove,
            onTap: value > min ? () => onChanged(value - 1) : null,
            emphasize: true,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (value < max)
            _StepBtn(
              icon: Icons.add,
              onTap: () => onChanged(value + 1),
              emphasize: true,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, this.onTap, this.emphasize = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: emphasize && onTap != null ? AppColors.primary : Colors.transparent,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: SizedBox(
          width: 40,
          height: 38,
          child: Icon(
            icon,
            size: 18,
            color: onTap == null
                ? AppColors.textMuted
                : emphasize
                    ? Colors.white
                    : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
