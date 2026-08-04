import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'by_optimun_label.dart';

/// Opción 3 — el logo ZOE es el origen del ripple (no un punto).
///
/// Secuencia:
/// 1) Fondo azul
/// 2) Aparece el logo en el centro
/// 3) El logo pulsa y dispara ripples
/// 4) Reveal circular del formulario
/// 5) El logo sube y el login queda debajo
class ZoeRippleLoginPage extends StatefulWidget {
  const ZoeRippleLoginPage({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<ZoeRippleLoginPage> createState() => _ZoeRippleLoginPageState();
}

class _ZoeRippleLoginPageState extends State<ZoeRippleLoginPage>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 4200);
  static const String _logoAsset = 'assets/images/zoe_logo.png';

  late final AnimationController _controller;

  late final Animation<double> _logoAppear;
  late final Animation<double> _logoPulse;
  late final Animation<double> _ripple;
  late final Animation<double> _reveal;
  late final Animation<double> _logoRise;
  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;
  late final Animation<double> _stagger;
  late final Animation<double> _byline;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    // 0–700 ms: aparece el logo en el centro.
    _logoAppear = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.17, curve: Curves.easeOutCubic),
    );

    // 500–1000 ms: pulso del logo antes del ripple.
    _logoPulse = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 12),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 6,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 76),
    ]).animate(_controller);

    // 900–2800 ms: ripples desde el logo.
    _ripple = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.22, 0.66, curve: Curves.easeOutCubic),
    );

    // 1000–2700 ms: reveal circular del formulario.
    _reveal = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.24, 0.64, curve: Curves.easeInOutCubic),
    );

    // 1600–2800 ms: el logo sube hacia arriba.
    _logoRise = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.66, curve: Curves.easeInOutCubic),
      ),
    );

    // Tras subir el logo: aparece “BY OPTIMUN”.
    _byline = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.70, 0.88, curve: Curves.easeOutCubic),
    );

    // 1800–3400 ms: formulario.
    _formFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.78, curve: Curves.easeOutCubic),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.82, curve: Curves.easeOutCubic),
      ),
    );

    _stagger = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.48, 0.95, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3F8C),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
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

                  final currentW =
                      lerpDouble(logoW, finalLogoW, _logoRise.value)!;
                  final currentH =
                      lerpDouble(logoH, finalLogoH, _logoRise.value)!;

                  // Centro exacto → sube; el logo es siempre el origen de la onda.
                  final centerY = constraints.maxHeight / 2;
                  final topY = constraints.maxHeight * 0.26;
                  final logoY = lerpDouble(centerY, topY, _logoRise.value)!;

                  final maxRipple = math.sqrt(
                        constraints.maxWidth * constraints.maxWidth +
                            constraints.maxHeight * constraints.maxHeight,
                      ) /
                      2;

                  return Stack(
                    children: [
                      // Ripples desde el centro del logo.
                      IgnorePointer(
                        child: CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: _LogoRipplePainter(
                            ripple: _ripple.value,
                            maxRadius: maxRipple,
                            origin: Offset(
                              constraints.maxWidth / 2,
                              logoY,
                            ),
                            startRadius: currentW * 0.42,
                          ),
                        ),
                      ),

                      // Formulario revelado en círculo desde el logo (lo acompaña).
                      ClipPath(
                        clipper: _CircleRevealClipper(
                          progress: _reveal.value,
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
                              opacity: _formFade,
                              child: SlideTransition(
                                position: _formSlide,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 400),
                                  child: SingleChildScrollView(
                                    child: _RippleLoginForm(
                                      reveal: _stagger.value,
                                      onLogin: widget.onSuccess,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Logo = origen del efecto / centro de la onda.
                      Positioned(
                        left: (constraints.maxWidth - currentW) / 2,
                        top: logoY - currentH / 2,
                        width: currentW,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Opacity(
                              opacity: _logoAppear.value,
                              child: Transform.scale(
                                scale: _logoAppear.value * _logoPulse.value,
                                child: Image.asset(
                                  _logoAsset,
                                  width: currentW,
                                  height: currentH,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ByOptimunLabel(
                              opacity: _byline.value,
                              slide: 1 - _byline.value,
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
        },
      ),
    );
  }
}

// =============================================================================
// Clipper — reveal circular desde el logo
// =============================================================================

class _CircleRevealClipper extends CustomClipper<Path> {
  _CircleRevealClipper({
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
  bool shouldReclip(covariant _CircleRevealClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.center != center;
  }
}

// =============================================================================
// Painter — ripples desde el logo (sin punto blanco)
// =============================================================================

class _LogoRipplePainter extends CustomPainter {
  _LogoRipplePainter({
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

    // Partículas suaves alrededor del logo al disparar el ripple.
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
  bool shouldRepaint(covariant _LogoRipplePainter oldDelegate) {
    return oldDelegate.ripple != ripple ||
        oldDelegate.maxRadius != maxRadius ||
        oldDelegate.origin != origin ||
        oldDelegate.startRadius != startRadius;
  }
}

// =============================================================================
// Formulario
// =============================================================================

class _RippleLoginForm extends StatefulWidget {
  const _RippleLoginForm({
    required this.reveal,
    this.onLogin,
  });

  final double reveal;
  final VoidCallback? onLogin;

  @override
  State<_RippleLoginForm> createState() => _RippleLoginFormState();
}

class _RippleLoginFormState extends State<_RippleLoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  double _piece(double start, double end) {
    final t = ((widget.reveal - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(t);
  }

  Widget _stagger({required double progress, required Widget child}) {
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 18 * (1 - progress)),
        child: child,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    required Color iconColor,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
      prefixIcon: Icon(icon, color: iconColor),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white70, width: 1.2),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    if (_email.text.trim().isEmpty || _password.text.length < 4) {
      setState(() {
        _loading = false;
        _error = 'Email y password (4+ caracteres) requeridos';
      });
      return;
    }
    setState(() => _loading = false);
    widget.onLogin?.call();
  }

  @override
  Widget build(BuildContext context) {
    final emailT = _piece(0.0, 0.35);
    final passT = _piece(0.18, 0.55);
    final btnT = _piece(0.35, 0.75);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _stagger(
          progress: emailT,
          child: TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              hint: 'email',
              icon: Icons.email_outlined,
              iconColor: const Color(0xFFFF6B6B),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _stagger(
          progress: passT,
          child: TextField(
            controller: _password,
            obscureText: _obscure,
            style: const TextStyle(color: Colors.white),
            onSubmitted: (_) => _submit(),
            decoration: _fieldDecoration(
              hint: 'password',
              icon: Icons.lock_outline,
              iconColor: const Color(0xFFFFD54F),
              suffix: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            style: const TextStyle(
              color: Color(0xFFFFB4B4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 22),
        _stagger(
          progress: btnT,
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D8DFF),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF3D8DFF).withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  fontSize: 15,
                ),
              ),
              child: Text(_loading ? '…' : 'LOGIN'),
            ),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
