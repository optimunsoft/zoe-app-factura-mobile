import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../modules/third-party/store/common.store.dart';

/// Campo de búsqueda y selección de municipio.
class CampoBusquedaMunicipio extends StatelessWidget {
  const CampoBusquedaMunicipio({
    super.key,
    required this.controller,
    required this.common,
    required this.selected,
    required this.onChanged,
    required this.onClear,
    required this.onSelect,
  });

  final TextEditingController controller;
  final CommonStore common;
  final Municipality? selected;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<Municipality> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Municipio *',
            hintText: 'Escribe al menos 2 letras…',
            helperText: selected == null
                ? 'Se buscan municipios mientras escribes'
                : 'Seleccionado: ${selected!.label}',
            suffixIcon: common.isLoadingMunicipalities
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    tooltip: 'Limpiar',
                    onPressed: onClear,
                    icon: const Icon(Icons.clear_rounded),
                  ),
          ),
          onChanged: onChanged,
          validator: (_) =>
              selected == null ? 'Selecciona un municipio' : null,
        ),
        if (common.municipalityError != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            common.municipalityError!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
          ),
        ],
        if (common.municipalities.isNotEmpty) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: AppRadius.mdAll,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: common.municipalities.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final item = common.municipalities[index];
                    final isSelected = selected?.id == item.id;
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      tileColor: AppColors.surface,
                      selectedTileColor: AppColors.primaryLight,
                      title: Text(
                        item.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        item.departamento,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, size: 18)
                          : null,
                      onTap: () => onSelect(item),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
