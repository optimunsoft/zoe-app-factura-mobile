import 'package:flutter/material.dart';

import '../../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../molecules/seccion_formulario.dart';

/// Sección: régimen IVA, responsabilidad fiscal y observaciones.
class SeccionTributaria extends StatelessWidget {
  const SeccionTributaria({
    super.key,
    required this.regimesIva,
    required this.fiscalResponsibilities,
    required this.vatRegimeCode,
    required this.fiscalRespCode,
    required this.observationsCtrl,
    required this.onVatRegimeChanged,
    required this.onFiscalRespChanged,
  });

  final List<RegimeIva> regimesIva;
  final List<FiscalResponsibility> fiscalResponsibilities;
  final String? vatRegimeCode;
  final String? fiscalRespCode;
  final TextEditingController observationsCtrl;
  final ValueChanged<String?> onVatRegimeChanged;
  final ValueChanged<String?> onFiscalRespChanged;

  @override
  Widget build(BuildContext context) {
    return SeccionFormulario(
      title: 'Datos tributarios',
      children: [
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: vatRegimeCode,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Régimen especial *'),
          items: regimesIva
              .map(
                (r) => DropdownMenuItem(
                  value: r.code,
                  child: Text(
                    r.regime,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              )
              .toList(),
          onChanged: onVatRegimeChanged,
          validator: (v) => v == null ? 'Requerido' : null,
        ),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: fiscalRespCode,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Responsabilidad tributaria / fiscal *',
          ),
          items: fiscalResponsibilities
              .map(
                (f) => DropdownMenuItem(
                  value: f.code,
                  child: Text(
                    f.responsibility,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              )
              .toList(),
          onChanged: onFiscalRespChanged,
          validator: (v) => v == null ? 'Requerido' : null,
        ),
        TextFormField(
          controller: observationsCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
