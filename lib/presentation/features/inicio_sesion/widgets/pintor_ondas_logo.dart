import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Painter — ripples desde el logo (sin punto blanco).
class PintorOndasLogo extends CustomPainter {
  PintorOndasLogo({
    required this.ripple,
    required this.maxRadius,
    required this.origin,
    required this.startRadius,
  });

  final double ripple;
  final double maxRadius;
  final Offset origin;
  final double startRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (ripple <= 0.01) return;

    for (var i = 0; i < 4; i++) {
      final local = (ripple - i * 0.11).clamp(0.0, 1.0);
      if (local <= 0) continue;

      final rr = lerpDouble(
        startRadius,
        maxRadius * 1.05,
        Curves.easeOutCubic.transform(local),
      )!;
      final stroke = lerpDouble(3.0, 0.5, local)!;
      final alpha = (1.0 - local) * (0.50 - i * 0.07);

      canvas.drawCircle(
        origin,
        rr,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = Colors.white.withValues(alpha: alpha.clamp(0.0, 0.5)),
      );

      if (i < 2) {
        canvas.drawCircle(
          origin,
          rr * 0.97,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = Colors.white.withValues(alpha: alpha * 0.3),
        );
      }
    }

    if (ripple < 0.4) {
      final burst = (ripple / 0.4).clamp(0.0, 1.0);
      for (var i = 0; i < 12; i++) {
        final a = i / 12 * math.pi * 2;
        final dist = startRadius * 0.9 + burst * 55 * (0.7 + (i % 3) * 0.15);
        canvas.drawCircle(
          Offset(
            origin.dx + math.cos(a) * dist,
            origin.dy + math.sin(a) * dist,
          ),
          (1.3 + (i % 3) * 0.6) * (1.0 - burst * 0.55),
          Paint()
            ..color = Colors.white.withValues(alpha: (1.0 - burst) * 0.65),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PintorOndasLogo oldDelegate) {
    return oldDelegate.ripple != ripple ||
        oldDelegate.maxRadius != maxRadius ||
        oldDelegate.origin != origin ||
        oldDelegate.startRadius != startRadius;
  }
}

/// Alias legacy — usar [PintorOndasLogo].
typedef LogoRipplePainter = PintorOndasLogo;
