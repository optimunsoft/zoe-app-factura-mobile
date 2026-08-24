import 'package:flutter/material.dart';

import '../../core/layout/ancho_vista.dart';
import '../../core/theme/app_breakpoints.dart';

/// Elige un hijo según [ClaseAncho]. Si falta un slot, usa el más estrecho definido.
class PlantillaAdaptativa extends StatelessWidget {
  const PlantillaAdaptativa({
    super.key,
    required this.movil,
    this.tablet,
    this.amplia,
  });

  final Widget movil;
  final Widget? tablet;
  final Widget? amplia;

  @override
  Widget build(BuildContext context) {
    return switch (AnchoVista.clase(context)) {
      ClaseAncho.movil => movil,
      ClaseAncho.tablet => tablet ?? movil,
      ClaseAncho.amplia => amplia ?? tablet ?? movil,
    };
  }
}

/// Lista / maestro a la izquierda y detalle a la derecha desde 840 dp.
class PlantillaDosColumnas extends StatelessWidget {
  const PlantillaDosColumnas({
    super.key,
    required this.principal,
    required this.detalle,
    this.flexPrincipal = 5,
    this.flexDetalle = 6,
    this.anchoDetalle,
    this.activo,
  });

  final Widget principal;
  final Widget detalle;
  final int flexPrincipal;
  final int flexDetalle;

  /// Si se informa, el detalle usa ancho fijo en lugar de flex.
  final double? anchoDetalle;

  /// Si es null, usa [AnchoVista.usaDosColumnas].
  final bool? activo;

  @override
  Widget build(BuildContext context) {
    final split = activo ?? AnchoVista.usaDosColumnas(context);
    if (!split) {
      return principal;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: flexPrincipal, child: principal),
        const VerticalDivider(width: 1),
        if (anchoDetalle != null)
          SizedBox(width: anchoDetalle, child: detalle)
        else
          Expanded(flex: flexDetalle, child: detalle),
      ],
    );
  }
}
