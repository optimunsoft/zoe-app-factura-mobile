/// Anchos de layout (dp lógicos). Usar [AnchoVista]; no ramificar por plataforma.
abstract final class AppBreakpoints {
  /// Teléfono: menos de este ancho.
  static const double movil = 600;

  /// Tablet vertical / pantalla mediana.
  static const double tablet = 840;

  /// Escritorio o tablet muy ancha: rail extendido.
  static const double escritorio = 1200;

  /// Alias: [movil].
  static const double compacto = movil;

  /// Alias: [tablet].
  static const double medio = tablet;

  /// Alias: [escritorio].
  static const double amplio = escritorio;

  /// Tope de contenido en dashboards y listas (no el catálogo POS).
  static const double anchoContenido = 1280;

  /// Ancho de sheets mostrados como diálogo.
  static const double anchoSheet = 520;

  /// Formulario de login.
  static const double anchoLogin = 420;
}

/// Clase de ancho para plantillas adaptativas.
enum ClaseAncho {
  /// Menos de 600 dp.
  movil,

  /// 600–840 dp.
  tablet,

  /// 840 dp o más.
  amplia,
}
