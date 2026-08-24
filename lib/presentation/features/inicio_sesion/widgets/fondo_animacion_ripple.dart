import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_breakpoints.dart';
import '../../../atoms/logo_zoe.dart';
import 'etiqueta_by_optimun.dart';
import 'formulario_login.dart';
import 'pintor_ondas_logo.dart';
import 'recorte_revelacion_circulo.dart';

/// Fondo animado con ripples, reveal circular y logo ZOE.
class FondoAnimacionRipple extends StatelessWidget {
  const FondoAnimacionRipple({
    super.key,
    required this.logoAppear,
    required this.logoPulse,
    required this.ripple,
    required this.reveal,
    required this.logoRise,
    required this.byline,
    required this.formFade,
    required this.formSlide,
    required this.stagger,
    this.onLogin,
    this.logoAsset = kZoeLogoInvertidoAsset,
  });

  final Animation<double> logoAppear;
  final Animation<double> logoPulse;
  final Animation<double> ripple;
  final Animation<double> reveal;
  final Animation<double> logoRise;
  final Animation<double> byline;
  final Animation<double> formFade;
  final Animation<Offset> formSlide;
  final Animation<double> stagger;
  final VoidCallback? onLogin;
  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.15),
          radius: 1.15,
          colors: [
            Color(0xFF2F7FE0),
            Color(0xFF1560C0),
            Color(0xFF0A3F8C),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortest = math.min(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final logoW = (shortest * 0.52).clamp(170.0, 260.0);
            final finalLogoW = logoW * 0.78;
            final logoH = logoW * 0.58;
            final finalLogoH = finalLogoW * 0.58;

            final currentW = lerpDouble(logoW, finalLogoW, logoRise.value)!;
            final currentH = lerpDouble(logoH, finalLogoH, logoRise.value)!;

            final centerY = constraints.maxHeight / 2;
            final topY = constraints.maxHeight * 0.26;
            final logoY = lerpDouble(centerY, topY, logoRise.value)!;

            final maxRipple = math.sqrt(
                  constraints.maxWidth * constraints.maxWidth +
                      constraints.maxHeight * constraints.maxHeight,
                ) /
                2;

            return Stack(
              children: [
                IgnorePointer(
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    painter: PintorOndasLogo(
                      ripple: ripple.value,
                      maxRadius: maxRipple,
                      origin: Offset(
                        constraints.maxWidth / 2,
                        logoY,
                      ),
                      startRadius: currentW * 0.42,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: RecorteRevelacionCirculo(
                    progress: reveal.value,
                    center: Offset(
                      constraints.maxWidth / 2,
                      logoY,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        28,
                        logoY + currentH / 2 + 72,
                        28,
                        24,
                      ),
                      child: FadeTransition(
                        opacity: formFade,
                        child: SlideTransition(
                          position: formSlide,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: AppBreakpoints.anchoLogin,
                            ),
                            child: SingleChildScrollView(
                              child: FormularioLogin(
                                reveal: stagger.value,
                                onLogin: onLogin,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (constraints.maxWidth - currentW) / 2,
                  top: logoY - currentH / 2,
                  width: currentW,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: logoAppear.value,
                        child: Transform.scale(
                          scale: logoAppear.value * logoPulse.value,
                          child: Image.asset(
                            logoAsset,
                            width: currentW,
                            height: currentH,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      EtiquetaByOptimun(
                        opacity: byline.value,
                        slide: 1 - byline.value,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
