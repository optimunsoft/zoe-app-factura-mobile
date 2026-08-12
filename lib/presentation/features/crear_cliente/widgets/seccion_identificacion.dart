import 'package:flutter/material.dart';

import '../../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../molecules/seccion_formulario.dart';

/// Sección: tipo de persona, documento e identificación.
class SeccionIdentificacion extends StatelessWidget {
  const SeccionIdentificacion({
    super.key,
    required this.personTypes,
    required this.documentTypes,
    required this.personTypeCode,
    required this.documentTypeId,
    required this.identificationCtrl,
    required this.verificationCtrl,
    required this.onPersonTypeChanged,
    required this.onDocumentTypeChanged,
    required this.onIdentificationChanged,
    required this.requiredText,
  });

  final List<PersonType> personTypes;
  final List<DocumentTypeItem> documentTypes;
  final String? personTypeCode;
  final int? documentTypeId;
  final TextEditingController identificationCtrl;
  final TextEditingController verificationCtrl;
  final ValueChanged<String?> onPersonTypeChanged;
  final ValueChanged<int?> onDocumentTypeChanged;
  final ValueChanged<String> onIdentificationChanged;
  final FormFieldValidator<String> requiredText;

  @override
  Widget build(BuildContext context) {
    return SeccionFormulario(
      title: 'Identificación',
      children: [
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: personTypeCode,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Tipo de persona *'),
          items: personTypes
              .map(
                (p) => DropdownMenuItem(
                  value: p.code,
                  child: Text(
                    p.type,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              )
              .toList(),
          onChanged: onPersonTypeChanged,
          validator: (v) => v == null ? 'Requerido' : null,
        ),
        DropdownButtonFormField<int>(
          // ignore: deprecated_member_use
          value: documentTypeId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Tipo de documento *'),
          items: documentTypes
              .map(
                (d) => DropdownMenuItem(
                  value: d.id,
                  child: Text(
                    d.type,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              )
              .toList(),
          onChanged: onDocumentTypeChanged,
          validator: (v) => v == null ? 'Requerido' : null,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: identificationCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'N° identificación *',
                ),
                onChanged: onIdentificationChanged,
                validator: requiredText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: verificationCtrl,
                readOnly: true,
                maxLength: 1,
                decoration: const InputDecoration(
                  labelText: 'DV',
                  counterText: '',
                  helperText: 'Auto',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
