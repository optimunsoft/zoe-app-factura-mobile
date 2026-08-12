import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/api_helpers.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../data/pos_controller.dart';

/// Formulario de login con animación escalonada y autenticación.
class FormularioLogin extends StatefulWidget {
  const FormularioLogin({
    super.key,
    required this.reveal,
    this.onLogin,
  });

  final double reveal;
  final VoidCallback? onLogin;

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
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
    final correo = _email.text.trim();
    final clave = _password.text;

    if (correo.isEmpty || clave.length < 4) {
      setState(() => _error = 'Email y password (4+ caracteres) requeridos');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      final result = await AuthService().login(
        correo: correo,
        clave: clave,
      );

      if (!mounted) return;

      context.read<AuthController>().setSession(result);
      context.read<PosController>().setIvaIncluido(result.user.ivaIncluido);
      setState(() => _loading = false);
      widget.onLogin?.call();
    } catch (e) {
      if (!mounted) return;
      final message = cleanErrorMessage(e);
      context.read<AuthController>().setError(message);
      setState(() {
        _loading = false;
        _error = message.isEmpty ? null : message;
      });
    }
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
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Text('LOGIN'),
            ),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
