import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_controller.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/tema_app_store.dart';
import '../molecules/encabezado_drawer.dart';
import '../molecules/item_drawer_navegacion.dart';
import 'destinos_navegacion.dart';

/// Drawer del shell: módulos de la app. No duplica las pestañas inferiores.
class DrawerNavegacion extends StatelessWidget {
  const DrawerNavegacion({
    super.key,
    required this.onLogout,
  });

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final tema = context.watch<TemaAppStore>();
    const venta = DestinosDrawer.venta;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EncabezadoDrawer(user: user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: [
                ItemDrawerNavegacion(
                  label: venta.label,
                  icon: venta.icon,
                  selectedIcon: venta.selectedIcon,
                  selected: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  ItemDrawerNavegacion(
                    label: 'Modo oscuro',
                    icon: tema.oscuro
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_outlined,
                    trailing: Switch.adaptive(
                      value: tema.oscuro,
                      onChanged: tema.setOscuro,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onTap: () => tema.setOscuro(!tema.oscuro),
                  ),
                  ItemDrawerNavegacion(
                    label: 'Cerrar sesión',
                    icon: Icons.logout_rounded,
                    danger: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      onLogout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
