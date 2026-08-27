import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/layout/ancho_vista.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/logo_zoe.dart';
import 'control_drawer_app.dart';
import 'destinos_navegacion.dart';

/// Navegación lateral estilo Windows: marca arriba y salida abajo.
/// En tablet solo se usa en orientación horizontal.
class NavLateralWindows extends StatelessWidget {
  const NavLateralWindows({
    super.key,
    required this.index,
    required this.onChanged,
    required this.onSalir,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final VoidCallback onSalir;

  static bool get esWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  /// Windows siempre; tablet solo en horizontal.
  static bool aplicaEn(BuildContext context) {
    if (kIsWeb) return false;
    if (esWindows) return true;
    return AnchoVista.esTabletDispositivo(context) &&
        AnchoVista.esHorizontal(context);
  }

  static const double _ancho = 80;
  static const double _extraAnchoTabletHorizontal = 10;
  static const double _altoLogo = 36;
  static const double _tamanoFirma = 7;
  static const double _tamanoIcono = 24;

  static bool _esTabletHorizontal(BuildContext context) =>
      !esWindows &&
      AnchoVista.esTabletDispositivo(context) &&
      AnchoVista.esHorizontal(context);

  static double _anchoDe(BuildContext context) {
    if (_esTabletHorizontal(context)) {
      return _ancho + _extraAnchoTabletHorizontal;
    }
    return _ancho;
  }

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final ancho = _anchoDe(context);
    final escala = ancho / _ancho;
    final altoLogo = _altoLogo * escala;
    final tamanoFirma = _tamanoFirma * escala;
    final tamanoIcono = _tamanoIcono * escala;
    final temaRail = Theme.of(context).navigationRailTheme;

    return Theme(
      data: Theme.of(context).copyWith(
        navigationRailTheme: temaRail.copyWith(
          selectedIconTheme: (temaRail.selectedIconTheme ?? const IconThemeData())
              .copyWith(size: tamanoIcono),
          unselectedIconTheme:
              (temaRail.unselectedIconTheme ?? const IconThemeData())
                  .copyWith(size: tamanoIcono),
          selectedLabelTextStyle: temaRail.selectedLabelTextStyle?.copyWith(
            fontSize: (temaRail.selectedLabelTextStyle?.fontSize ?? 13) *
                escala,
          ),
          unselectedLabelTextStyle: temaRail.unselectedLabelTextStyle?.copyWith(
            fontSize: (temaRail.unselectedLabelTextStyle?.fontSize ?? 12) *
                escala,
          ),
        ),
      ),
      child: NavigationRail(
        selectedIndex: index,
        onDestinationSelected: onChanged,
        labelType: NavigationRailLabelType.all,
        groupAlignment: -1,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.oscuro
            ? AppColors.primary.withValues(alpha: 0.35)
            : AppColors.primaryLight,
        minWidth: ancho,
        leading: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.lg,
          ),
          child: SizedBox(
            width: ancho - AppSpacing.md,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ControlDrawerApp.abrir(context),
                  borderRadius: AppRadius.mdAll,
                  child: LogoZoeConFirma(
                    logoHeight: altoLogo,
                    firmaSize: tamanoFirma,
                    invertido: oscuro,
                    firmaColor: oscuro
                        ? Colors.white.withValues(alpha: 0.78)
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
        trailing: Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Tooltip(
                message: 'Cerrar sesión',
                child: IconButton(
                  onPressed: onSalir,
                  iconSize: tamanoIcono,
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                ),
              ),
            ),
          ),
        ),
        destinations: [
          for (final destino in DestinosNavegacionPrincipal.todos)
            NavigationRailDestination(
              icon: Icon(destino.icon, size: tamanoIcono),
              selectedIcon: Icon(
                destino.selectedIcon,
                size: tamanoIcono,
                color: AppColors.primary,
              ),
              label: Text(destino.label),
            ),
        ],
      ),
    );
  }
}
