import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lectura de insets de sistema (barras de navegación nativas, recortes).
///
/// En tablet horizontal el shell usa rail y no hay [NavigationBar]; el cuerpo
/// debe respetar una barra nativa inferior o lateral si el SO la reporta.
abstract final class AreaSegura {
  static EdgeInsets viewPaddingDe(BuildContext context) =>
      MediaQuery.viewPaddingOf(context);

  /// Alto de la barra / gesto inferior. 0 si el dispositivo no la tiene.
  static double inferior(BuildContext context) =>
      viewPaddingDe(context).bottom;

  static bool hayBarraInferior(BuildContext context) => inferior(context) > 0;

  /// Insets laterales e inferior: usa [viewPadding] si el SO lo reporta y
  /// [padding] aún no lo incluye. El superior lo manejan los AppBar.
  static EdgeInsets paddingEfectivo(BuildContext context) {
    final media = MediaQuery.of(context);
    return EdgeInsets.fromLTRB(
      math.max(media.padding.left, media.viewPadding.left),
      media.padding.top,
      math.max(media.padding.right, media.viewPadding.right),
      math.max(media.padding.bottom, media.viewPadding.bottom),
    );
  }
}

/// Reserva el área segura inferior y derecha cuando el shell no tiene
/// navegación inferior propia (tablet horizontal / escritorio).
///
/// Si el sistema no reporta inset, no agrega espacio.
class CuerpoAreaSegura extends StatelessWidget {
  const CuerpoAreaSegura({
    super.key,
    required this.activo,
    required this.child,
  });

  final bool activo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!activo) return child;

    return SafeArea(
      top: false,
      left: false,
      maintainBottomViewPadding: true,
      child: child,
    );
  }
}
