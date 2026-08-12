import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';

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
            (c) => InputChip(
              label: Text(c.label, style: AppTextStyles.caption),
              onDeleted: c.onClear,
              deleteIconColor: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          AppButton(
            label: 'Limpiar',
            expanded: false,
            height: 28,
            compact: true,
            variant: AppButtonVariant.primary,
            onPressed: onClearAll,
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
