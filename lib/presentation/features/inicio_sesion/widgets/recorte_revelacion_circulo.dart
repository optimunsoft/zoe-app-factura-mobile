import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Clipper — reveal circular desde el logo.
class RecorteRevelacionCirculo extends CustomClipper<Path> {
  RecorteRevelacionCirculo({
    required this.progress,
    required this.center,
  });

  final double progress;
  final Offset center;

  @override
  Path getClip(Size size) {
    final maxR = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    final r = maxR * progress.clamp(0.0, 1.0);
    return Path()..addOval(Rect.fromCircle(center: center, radius: r));
  }

  @override
  bool shouldReclip(covariant RecorteRevelacionCirculo oldClipper) {
    return oldClipper.progress != progress || oldClipper.center != center;
  }
}

/// Alias legacy — usar [RecorteRevelacionCirculo].
typedef CircleRevealClipper = RecorteRevelacionCirculo;
