import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

/// Chip activo de filtro.
class ChipFiltroActivo {
  const ChipFiltroActivo({
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback onClear;
}

/// Barra de filtros activos con opción de limpiar todo.
class BarraFiltrosActivos extends StatelessWidget {
  const BarraFiltrosActivos({
    super.key,
    required this.chips,
    required this.onClearAll,
  });

  final List<ChipFiltroActivo> chips;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...chips.map(
            (c) => SizedBox(
              height: 32,
              child: InputChip(
                label: Text(c.label, style: AppTextStyles.caption),
                onDeleted: c.onClear,
                deleteIconColor: AppColors.primary,
                backgroundColor: AppColors.primaryLight,
                side: BorderSide.none,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: onClearAll,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 32),
                maximumSize: const Size(double.infinity, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              child: const Text('Limpiar'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [BarraFiltrosActivos].
typedef ActiveFiltersBar = BarraFiltrosActivos;

/// Alias legacy — usar [ChipFiltroActivo].
typedef ActiveFilterChip = ChipFiltroActivo;
