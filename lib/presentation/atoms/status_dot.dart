import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusDot extends StatelessWidget {
  const StatusDot({
    super.key,
    required this.active,
    this.size = 8,
  });

  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.success : AppColors.danger,
        boxShadow: [
          BoxShadow(
            color: (active ? AppColors.success : AppColors.danger).withValues(alpha: 0.45),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
