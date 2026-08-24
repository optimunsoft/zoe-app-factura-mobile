import 'package:flutter/material.dart';

/// Envuelve el contenido de dashboards. El ancho lo define el padding de
/// [AnchoVista], igual en tablet y Windows (sin columna centrada).
class ContenidoAnchoMaximo extends StatelessWidget {
  const ContenidoAnchoMaximo({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

