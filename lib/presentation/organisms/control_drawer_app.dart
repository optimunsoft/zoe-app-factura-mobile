import 'package:flutter/material.dart';

/// Expone [openDrawer] del scaffold del shell a las AppBars anidadas.
class ControlDrawerApp extends InheritedWidget {
  const ControlDrawerApp({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  final VoidCallback openDrawer;

  static void abrir(BuildContext context) {
    final control = context
        .dependOnInheritedWidgetOfExactType<ControlDrawerApp>();
    control?.openDrawer();
  }

  @override
  bool updateShouldNotify(ControlDrawerApp oldWidget) {
    return openDrawer != oldWidget.openDrawer;
  }
}
