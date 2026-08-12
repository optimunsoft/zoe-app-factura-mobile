import 'package:flutter/material.dart';

import '../../../molecules/seccion_formulario.dart';

/// Sección: flags extranjero / zona franca / ZOMAC.
class SeccionCondiciones extends StatelessWidget {
  const SeccionCondiciones({
    super.key,
    required this.foreign,
    required this.freeZone,
    required this.zomac,
    required this.onForeignChanged,
    required this.onFreeZoneChanged,
    required this.onZomacChanged,
  });

  final bool foreign;
  final bool freeZone;
  final bool zomac;
  final ValueChanged<bool> onForeignChanged;
  final ValueChanged<bool> onFreeZoneChanged;
  final ValueChanged<bool> onZomacChanged;

  @override
  Widget build(BuildContext context) {
    return SeccionFormulario(
      title: 'Condiciones',
      children: [
        InterruptorBandera(
          label: 'Extranjero *',
          value: foreign,
          onChanged: onForeignChanged,
        ),
        InterruptorBandera(
          label: 'Zona franca',
          value: freeZone,
          onChanged: onFreeZoneChanged,
        ),
        InterruptorBandera(
          label: 'ZOMAC',
          value: zomac,
          onChanged: onZomacChanged,
        ),
      ],
    );
  }
}
