import 'package:flutter/material.dart';

import '../theme/app_breakpoints.dart';
import '../theme/app_spacing.dart';

/// Lectura del ancho disponible. Preferir esto a `Platform.isAndroid` / Windows.
abstract final class AnchoVista {
  static double de(BuildContext context) => MediaQuery.sizeOf(context).width;

  static ClaseAncho clase(BuildContext context) => claseDe(de(context));

  static ClaseAncho claseDe(double width) {
    if (width < AppBreakpoints.movil) return ClaseAncho.movil;
    if (width < AppBreakpoints.tablet) return ClaseAncho.tablet;
    return ClaseAncho.amplia;
  }

  static bool esMovil(BuildContext context) =>
      de(context) < AppBreakpoints.movil;

  static bool esTablet(BuildContext context) {
    final w = de(context);
    return w >= AppBreakpoints.movil && w < AppBreakpoints.tablet;
  }

  static bool esAmplia(BuildContext context) =>
      de(context) >= AppBreakpoints.tablet;

  static bool esEscritorio(BuildContext context) =>
      de(context) >= AppBreakpoints.escritorio;

  /// Alias de compatibilidad (antes menor a 840). Ahora es teléfono.
  static bool esCompacto(BuildContext context) => esMovil(context);

  /// Alias: [esEscritorio].
  static bool esAmplio(BuildContext context) => esEscritorio(context);

  /// Sidebar / NavigationRail desde tablet (600 dp).
  static bool usaRail(BuildContext context) =>
      de(context) >= AppBreakpoints.movil;

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

  /// Padding de página: el mismo en tablet y Windows.
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
  static int columnasProducto(double width) {
    const minCard = 168.0;
    const pad = 32.0;
    const spacing = 12.0;
    final available = width - pad;
    if (available <= minCard) return 1;
    final count = ((available + spacing) / (minCard + spacing)).floor();
    final maxCols = width < AppBreakpoints.movil ? 2 : 4;
    final minCols = width < 360 ? 1 : 2;
    return count.clamp(minCols, maxCols);
  }

  static int columnasResumen(double width) {
    if (width >= AppBreakpoints.tablet) return 4;
    return 2;
  }

  static int columnasAccesos(double width) {
    return width >= AppBreakpoints.movil ? 3 : 2;
  }
}
