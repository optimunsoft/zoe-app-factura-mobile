import 'package:flutter/material.dart';

import '../../../atoms/logo_zoe.dart';

/// Pequeña etiqueta “BY OPTIMUN” bajo el logo ZOE.
class EtiquetaByOptimun extends StatelessWidget {
  const EtiquetaByOptimun({
    super.key,
    required this.opacity,
    this.slide = 0,
  });

  final double opacity;
  final double slide;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 10 * slide),
        child: Text(
          kZoeFirmaTexto,
          textAlign: TextAlign.center,
          style: estiloFirmaZoe(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [EtiquetaByOptimun].
typedef ByOptimunLabel = EtiquetaByOptimun;
