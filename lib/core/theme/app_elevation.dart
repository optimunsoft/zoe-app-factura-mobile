import 'package:flutter/material.dart';

/// Sombras centralizadas del design system.
///
/// Regla: los contenedores informativos se delimitan solo con borde. La sombra
/// se reserva para superficies interactivas ([card]) y flotantes ([floating]).
abstract final class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Barra acoplada al borde inferior: la sombra sube hacia el contenido.
  static List<BoxShadow> get bar => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ];
}
