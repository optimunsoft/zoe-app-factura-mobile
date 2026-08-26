import 'package:flutter/material.dart';

import '../theme/app_breakpoints.dart';
import '../theme/app_spacing.dart';

/// Lectura del ancho disponible. Preferir esto a `Platform.isAndroid` / Windows.
abstract final class AnchoVista {
  static double de(BuildContext context) => MediaQuery.sizeOf(context).width;

  static ClaseAncho clase(BuildContext context) {
    if (comoMovil(context)) return ClaseAncho.movil;
    return claseDe(de(context));
  }

  static ClaseAncho claseDe(double width) {
    if (width < AppBreakpoints.movil) return ClaseAncho.movil;
    if (width < AppBreakpoints.tablet) return ClaseAncho.tablet;
    return ClaseAncho.amplia;
  }

  /// Teléfono, o tablet en vertical: mismo layout que el móvil.
  static bool comoMovil(BuildContext context) {
    if (esTabletDispositivo(context) && !esHorizontal(context)) return true;
    return de(context) < AppBreakpoints.movil;
  }

  static bool esMovil(BuildContext context) =>
      clase(context) == ClaseAncho.movil;

  static bool esTablet(BuildContext context) =>
      clase(context) == ClaseAncho.tablet;

  static bool esAmplia(BuildContext context) =>
      clase(context) == ClaseAncho.amplia;

  static bool esEscritorio(BuildContext context) =>
      de(context) >= AppBreakpoints.escritorio;

  /// Alias de compatibilidad (antes menor a 840). Ahora es teléfono.
  static bool esCompacto(BuildContext context) => esMovil(context);

  /// Alias: [esEscritorio].
  static bool esAmplio(BuildContext context) => esEscritorio(context);

  /// Tablet física (Material): el lado corto es ≥ 600 dp, da igual la rotación.
  static bool esTabletDispositivo(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= AppBreakpoints.movil;

  static bool esHorizontal(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// Carrito / listas a dos columnas. No aplica en tablet vertical.
  static bool usaRail(BuildContext context) => !comoMovil(context);

  /// Rail compacto (icono + etiqueta), igual en tablet y Windows.
  static bool railExtendido(BuildContext context) => false;

  /// Lista + detalle (historial, etc.).
  static bool usaDosColumnas(BuildContext context) => esAmplia(context);

  /// Carrito fijo a la derecha: tablet y escritorio.
  static bool usaPanelCarrito(BuildContext context) => usaRail(context);

  static double anchoPanelCarrito(BuildContext context) {
    return de(context) >= AppBreakpoints.tablet ? 360 : 300;
  }

  /// Sheets como diálogo centrado (tablet landscape / escritorio).
  static bool usaDialogoSheet(BuildContext context) => esAmplia(context);

  /// Padding de página: móvil (y tablet vertical) vs Windows / tablet horizontal.
  static EdgeInsets paddingPagina(
    BuildContext context, {
    double? top,
    double? bottom,
  }) {
    final h = esMovil(context) ? AppSpacing.lg : AppSpacing.xl;
    return EdgeInsets.fromLTRB(
      h,
      top ?? AppSpacing.sm,
      h,
      bottom ?? AppSpacing.lg,
    );
  }

  static double paddingHorizontal(BuildContext context) {
    return esMovil(context) ? AppSpacing.lg : AppSpacing.xl;
  }

  /// Columnas del catálogo POS según el ancho del [LayoutBuilder].
  static int columnasProducto(BuildContext context, double width) {
    const minCard = 168.0;
    const pad = 32.0;
    const spacing = 12.0;
    final available = width - pad;
    if (available <= minCard) return 1;
    final count = ((available + spacing) / (minCard + spacing)).floor();
    final maxCols = comoMovil(context) ? 2 : 4;
    final minCols = width < 360 ? 1 : 2;
    return count.clamp(minCols, maxCols);
  }

  static int columnasResumen(BuildContext context, double width) {
    if (comoMovil(context)) return 2;
    if (width >= AppBreakpoints.tablet) return 4;
    return 2;
  }

  static int columnasAccesos(BuildContext context, double width) {
    if (comoMovil(context)) return 2;
    return width >= AppBreakpoints.movil ? 3 : 2;
  }
}
