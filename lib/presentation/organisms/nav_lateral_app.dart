import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'destinos_navegacion.dart';

/// Navegación lateral para ventanas medianas y amplias.
class NavLateralApp extends StatelessWidget {
  const NavLateralApp({
    super.key,
    required this.index,
    required this.onChanged,
    this.extended = false,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: index,
      onDestinationSelected: onChanged,
      extended: extended,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.oscuro
          ? AppColors.primary.withValues(alpha: 0.35)
          : AppColors.primaryLight,
      minWidth: 72,
      minExtendedWidth: 168,
      destinations: [
        for (final destino in DestinosNavegacionPrincipal.todos)
          NavigationRailDestination(
            icon: Icon(destino.icon),
            selectedIcon: Icon(
              destino.selectedIcon,
              color: AppColors.primary,
            ),
            label: Text(destino.label),
          ),
      ],
    );
  }
}
