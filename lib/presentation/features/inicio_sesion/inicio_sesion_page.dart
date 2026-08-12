import 'package:flutter/material.dart';

import 'widgets/fondo_animacion_ripple.dart';

/// Opción 3 — el logo ZOE es el origen del ripple (no un punto).
///
/// Secuencia:
/// 1) Fondo azul
/// 2) Aparece el logo en el centro
/// 3) El logo pulsa y dispara ripples
/// 4) Reveal circular del formulario
/// 5) El logo sube y el login queda debajo
class InicioSesionPage extends StatefulWidget {
  const InicioSesionPage({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<InicioSesionPage> createState() => _InicioSesionPageState();
}

class _InicioSesionPageState extends State<InicioSesionPage>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 4200);

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

    _logoAppear = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.17, curve: Curves.easeOutCubic),
    );

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

    _ripple = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.22, 0.66, curve: Curves.easeOutCubic),
    );

    _reveal = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.24, 0.64, curve: Curves.easeInOutCubic),
    );

    _logoRise = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.66, curve: Curves.easeInOutCubic),
      ),
    );

    _byline = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.70, 0.88, curve: Curves.easeOutCubic),
    );

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
          return FondoAnimacionRipple(
            logoAppear: _logoAppear,
            logoPulse: _logoPulse,
            ripple: _ripple,
            reveal: _reveal,
            logoRise: _logoRise,
            byline: _byline,
            formFade: _formFade,
            formSlide: _formSlide,
            stagger: _stagger,
            onLogin: widget.onSuccess,
          );
        },
      ),
    );
  }
}

/// Alias legacy — usar [InicioSesionPage].
typedef ZoeRippleLoginPage = InicioSesionPage;
