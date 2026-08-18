import 'package:flutter/material.dart';
import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'destinos_navegacion.dart';

class NavInferiorApp extends StatelessWidget {
  const NavInferiorApp({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: AppBorders.top),
      child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onChanged,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.oscuro
            ? AppColors.primary.withValues(alpha: 0.35)
            : AppColors.primaryLight,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final destino in DestinosNavegacionPrincipal.todos)
            NavigationDestination(
              icon: Icon(destino.icon),
              selectedIcon: Icon(
                destino.selectedIcon,
                color: AppColors.primary,
              ),
              label: destino.label,
            ),
        ],
      ),
    );
  }
}

class BarraAccionFlotante extends StatelessWidget {
  const BarraAccionFlotante({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgAll,
          border: AppBorders.subtle,
          boxShadow: AppShadows.floating,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

/// Alias legacy — usar [NavInferiorApp].
typedef AppBottomNav = NavInferiorApp;

/// Alias legacy — usar [BarraAccionFlotante].
typedef FloatingActionBar = BarraAccionFlotante;
