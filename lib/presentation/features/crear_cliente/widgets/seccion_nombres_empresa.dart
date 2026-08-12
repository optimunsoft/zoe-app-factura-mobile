import 'package:flutter/material.dart';

import '../../../molecules/seccion_formulario.dart';

/// Sección: nombres (persona natural) o razón social (empresa).
class SeccionNombresEmpresa extends StatelessWidget {
  const SeccionNombresEmpresa({
    super.key,
    required this.isNatural,
    required this.companyNameCtrl,
    required this.firstNameCtrl,
    required this.middleNameCtrl,
    required this.lastNameCtrl,
    required this.secondLastNameCtrl,
    required this.requiredText,
  });

  final bool isNatural;
  final TextEditingController companyNameCtrl;
  final TextEditingController firstNameCtrl;
  final TextEditingController middleNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController secondLastNameCtrl;
  final FormFieldValidator<String> requiredText;

  @override
  Widget build(BuildContext context) {
    return SeccionFormulario(
      title: isNatural ? 'Nombres' : 'Empresa',
      children: [
        if (isNatural) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstNameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Primer nombre *',
                  ),
                  validator: requiredText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: middleNameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Segundo nombre',
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: lastNameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Primer apellido *',
                  ),
                  validator: requiredText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: secondLastNameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Segundo apellido',
                  ),
                ),
              ),
            ],
          ),
        ] else
          TextFormField(
            controller: companyNameCtrl,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(labelText: 'Razón social *'),
            validator: requiredText,
          ),
      ],
    );
  }
}
