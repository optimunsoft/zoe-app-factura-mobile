import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../organisms/control_drawer_app.dart';
import 'logo_zoe.dart';

/// Abre el drawer del shell principal. Usa el logo como disparador.
class BotonMenuDrawer extends StatelessWidget {
  const BotonMenuDrawer({super.key, this.compacto = false});

  /// Sin padding izquierdo extra (filas de AppBar personalizadas).
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Menú',
      child: InkWell(
        onTap: () => ControlDrawerApp.abrir(context),
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: compacto
              ? const EdgeInsets.symmetric(horizontal: AppSpacing.xs)
              : const EdgeInsets.only(left: AppSpacing.lg),
          child: const Center(child: LogoZoe(height: 34)),
        ),
      ),
    );
  }
}
