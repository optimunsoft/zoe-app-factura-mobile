import 'package:flutter/material.dart';

/// Paleta semántica de un modo (claro / oscuro).
class PaletaColores {
  const PaletaColores({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.successBg,
    required this.warningBg,
    required this.dangerBg,
    required this.textoSeleccionado,
  });

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
  final Color successBg;
  final Color warningBg;
  final Color dangerBg;
  final Color textoSeleccionado;
}

/// Tokens de color. Las superficies y textos siguen el modo activo.
abstract final class AppColors {
  static bool _oscuro = false;

  static bool get oscuro => _oscuro;

  static void aplicarOscuro(bool value) => _oscuro = value;

  static const PaletaColores clara = PaletaColores(
    primary: Color(0xFF007BFF),
    primaryDark: Color(0xFF0056B3),
    primaryLight: Color(0xFFE8F2FF),
    background: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEF1F6),
    textPrimary: Color(0xFF0D1117),
    textSecondary: Color(0xFF4A5568),
    textMuted: Color(0xFF718096),
    border: Color(0xFFD0D7E2),
    borderStrong: Color(0xFFA0AEC0),
    successBg: Color(0xFFE6F7ED),
    warningBg: Color(0xFFFFF4E5),
    dangerBg: Color(0xFFFEE2E2),
    textoSeleccionado: Color(0xFF0056B3),
  );

  /// Oscuro: #2F1B61 fondo, #2A2775 tarjetas, #4B73C2 acento/borde.
  static const PaletaColores oscura = PaletaColores(
    primary: Color(0xFF4B73C2),
    primaryDark: Color(0xFF4B73C2),
    primaryLight: Color(0xFF2F1B61),
    background: Color(0xFF2F1B61),
    surface: Color(0xFF2A2775),
    surfaceAlt: Color(0xFF322E80),
    textPrimary: Color(0xFFF4F6FB),
    textSecondary: Color(0xFFC5D0EB),
    textMuted: Color(0xFF9AABD4),
    border: Color(0xFF4B73C2),
    borderStrong: Color(0xFF6B8AD0),
    successBg: Color(0xFF1A3D38),
    warningBg: Color(0xFF3D2A40),
    dangerBg: Color(0xFF4A2248),
    textoSeleccionado: Color(0xFFD4DFF5),
  );

  static PaletaColores get actual => _oscuro ? oscura : clara;

  static Color get primary => actual.primary;
  static Color get primaryDark => actual.primaryDark;
  static Color get primaryLight => actual.primaryLight;
  static Color get background => actual.background;
  static Color get surface => actual.surface;
  static Color get surfaceAlt => actual.surfaceAlt;
  static Color get textPrimary => actual.textPrimary;
  static Color get textSecondary => actual.textSecondary;
  static Color get textMuted => actual.textMuted;
  static Color get border => actual.border;
  static Color get borderStrong => actual.borderStrong;
  static Color get successBg => actual.successBg;
  static Color get warningBg => actual.warningBg;
  static Color get dangerBg => actual.dangerBg;
  static Color get textoSeleccionado => actual.textoSeleccionado;

  static const Color success = Color(0xFF0F9D58);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);

  static const Color receiptBg = Color(0xFFFFFDF8);
  static const Color receiptLine = Color(0xFF1A1A1A);
}
