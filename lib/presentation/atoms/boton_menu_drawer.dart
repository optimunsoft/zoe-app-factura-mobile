import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../organisms/control_drawer_app.dart';
import 'logo_zoe.dart';

/// Abre el drawer del shell principal. Usa el logo como disparador.
class BotonMenuDrawer extends StatelessWidget {
  const BotonMenuDrawer({super.key, this.compacto = false});

  /// Ancho del `leading` para que la firma no se corte.
  static const double anchoLeading = 120;

  /// Sin padding izquierdo extra (filas de AppBar personalizadas).
  final bool compacto;

  @override
  Widget build(BuildContext context) {
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
