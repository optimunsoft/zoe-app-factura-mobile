import 'package:flutter/material.dart';

/// Envuelve el contenido de dashboards. El ancho lo define el padding de
/// [AnchoVista] (móvil y tablet vertical vs Windows / tablet horizontal).
class ContenidoAnchoMaximo extends StatelessWidget {
  const ContenidoAnchoMaximo({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

