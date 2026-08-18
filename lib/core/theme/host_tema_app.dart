import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tema_app_store.dart';

/// Envuelve el árbol de la app y, al cambiar el tema, marca todo el
/// subárbol sucio en el mismo frame. Evita el pintado a trozos entre
/// widgets de Theme y los que leen [AppColors].
class HostTemaApp extends StatefulWidget {
  const HostTemaApp({super.key, required this.child});

  final Widget child;

  @override
  State<HostTemaApp> createState() => _HostTemaAppState();
}

class _HostTemaAppState extends State<HostTemaApp> {
  TemaAppStore? _tema;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tema = context.read<TemaAppStore>();
    if (!identical(_tema, tema)) {
      _tema?.removeListener(_reconstruirArbol);
      _tema = tema;
      _tema!.addListener(_reconstruirArbol);
    }
  }

  @override
  void dispose() {
    _tema?.removeListener(_reconstruirArbol);
    super.dispose();
  }

  void _reconstruirArbol() {
    if (!mounted) return;
    void marcar(Element element) {
      element.markNeedsBuild();
      element.visitChildren(marcar);
    }

    marcar(context as Element);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
