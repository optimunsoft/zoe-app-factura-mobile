import 'package:flutter/material.dart';

import '../../../molecules/seccion_formulario.dart';

/// Sección: persona de contacto, correo y teléfonos.
class SeccionContacto extends StatelessWidget {
  const SeccionContacto({
    super.key,
    required this.contactPersonCtrl,
    required this.emailCtrl,
    required this.phone1Ctrl,
    required this.phone2Ctrl,
    required this.requiredText,
    required this.requiredEmail,
  });

  final TextEditingController contactPersonCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phone1Ctrl;
  final TextEditingController phone2Ctrl;
  final FormFieldValidator<String> requiredText;
  final FormFieldValidator<String> requiredEmail;

  @override
  Widget build(BuildContext context) {
    return SeccionFormulario(
      title: 'Contacto',
      children: [
        TextFormField(
          controller: contactPersonCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Persona de contacto *',
          ),
          validator: requiredText,
        ),
        TextFormField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Correo *'),
          validator: requiredEmail,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: phone1Ctrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono 1 *'),
                validator: requiredText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: phone2Ctrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono 2'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
