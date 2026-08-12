import 'package:flutter/material.dart';

import '../../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../../modules/third-party/store/common.store.dart';
import '../../../molecules/campo_busqueda_municipio.dart';
import '../../../molecules/seccion_formulario.dart';

/// Sección: dirección y municipio.
class SeccionUbicacion extends StatelessWidget {
  const SeccionUbicacion({
    super.key,
    required this.addressCtrl,
    required this.municipalitySearchCtrl,
    required this.common,
    required this.selectedMunicipality,
    required this.onMunicipalitySearch,
    required this.onMunicipalityClear,
    required this.onMunicipalitySelect,
    required this.requiredText,
  });

  final TextEditingController addressCtrl;
  final TextEditingController municipalitySearchCtrl;
  final CommonStore common;
  final Municipality? selectedMunicipality;
  final ValueChanged<String> onMunicipalitySearch;
  final VoidCallback onMunicipalityClear;
  final ValueChanged<Municipality> onMunicipalitySelect;
  final FormFieldValidator<String> requiredText;

  @override
  Widget build(BuildContext context) {
    return SeccionFormulario(
      title: 'Ubicación',
      children: [
        TextFormField(
          controller: addressCtrl,
          decoration: const InputDecoration(labelText: 'Dirección *'),
          validator: requiredText,
        ),
        CampoBusquedaMunicipio(
          controller: municipalitySearchCtrl,
          common: common,
          selected: selectedMunicipality,
          onChanged: onMunicipalitySearch,
          onClear: onMunicipalityClear,
          onSelect: onMunicipalitySelect,
        ),
      ],
    );
  }
}
