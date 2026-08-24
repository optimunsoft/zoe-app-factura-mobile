import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Scroll con rueda del mouse y trackpad (escritorio / web).
class ComportamientoScrollApp extends MaterialScrollBehavior {
  const ComportamientoScrollApp();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
