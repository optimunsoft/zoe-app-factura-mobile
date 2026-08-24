import 'package:flutter/material.dart';

/// Destino de navegación (pestaña o ítem del drawer).
class DestinoNavegacion {
  const DestinoNavegacion({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Catálogo de pestañas del módulo Venta (barra inferior o rail).
abstract final class DestinosNavegacionPrincipal {
  static const inicio = DestinoNavegacion(
    index: 0,
    label: 'Inicio',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  );

  static const venta = DestinoNavegacion(
    index: 1,
    label: 'Venta',
    icon: Icons.point_of_sale_outlined,
    selectedIcon: Icons.point_of_sale_rounded,
  );

  static const facturas = DestinoNavegacion(
    index: 2,
    label: 'Facturas',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long_rounded,
  );

  static const reportes = DestinoNavegacion(
    index: 3,
    label: 'Reportes',
    icon: Icons.analytics_outlined,
    selectedIcon: Icons.analytics_rounded,
  );

  static const List<DestinoNavegacion> todos = [
    inicio,
    venta,
    facturas,
    reportes,
  ];
}

/// Opciones del Navigation Drawer (módulos de la app, no pestañas).
abstract final class DestinosDrawer {
  static const venta = DestinoNavegacion(
    index: 0,
    label: 'Venta',
    icon: Icons.point_of_sale_outlined,
    selectedIcon: Icons.point_of_sale_rounded,
  );
}
