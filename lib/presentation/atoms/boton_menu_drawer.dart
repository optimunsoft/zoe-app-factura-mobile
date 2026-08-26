import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../organisms/control_drawer_app.dart';
import '../organisms/nav_lateral_windows.dart';
import 'logo_zoe.dart';

/// Abre el drawer del shell principal. Usa el logo como disparador.
/// Con [NavLateralWindows] no se muestra: logo y salida viven en la barra.
class BotonMenuDrawer extends StatelessWidget {
  const BotonMenuDrawer({super.key, this.compacto = false});

  /// Ancho del `leading` para que la firma no se corte.
  static const double anchoLeading = 120;

  /// Oculto cuando la barra lateral ya muestra logo y salida.
  static bool visibleEn(BuildContext context) =>
      !NavLateralWindows.aplicaEn(context);

  static double? leadingWidthDe(BuildContext context) =>
      visibleEn(context) ? anchoLeading : null;

  static Widget? leadingDe(BuildContext context, {bool compacto = false}) =>
      visibleEn(context) ? BotonMenuDrawer(compacto: compacto) : null;

  /// Sin padding izquierdo extra (filas de AppBar personalizadas).
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    if (!visibleEn(context)) return const SizedBox.shrink();

    final oscuro = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: 'Menú',
      child: InkWell(
        onTap: () => ControlDrawerApp.abrir(context),
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: compacto
              ? const EdgeInsets.symmetric(horizontal: AppSpacing.xs)
              : const EdgeInsets.only(left: AppSpacing.md),
          child: Align(
            alignment: Alignment.center,
            child: LogoZoeConFirma(
              logoHeight: compacto ? 30 : 38,
              firmaSize: 8,
              invertido: oscuro,
              firmaColor: oscuro
                  ? Colors.white.withValues(alpha: 0.78)
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
