import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/services/whatsapp_share_service.dart';
import '../../core/theme/app_text_styles.dart';

/// Color característico de WhatsApp.
const Color kWhatsAppGreen = Color(0xFF25D366);

/// Botón que abre el share sheet (WhatsApp, etc.).
///
/// Si [bytes] no es null, comparte ese archivo; si no, genera un txt de prueba.
class BotonWhatsAppShare extends StatefulWidget {
  const BotonWhatsAppShare({
    super.key,
    this.label = 'Compartir por WhatsApp',
    this.nombreArchivo,
    this.mensaje,
    this.bytes,
    this.mimeType = 'application/pdf',
    this.enabled = true,
    this.expanded = true,
    this.height = 52,
    this.service,
    this.onError,
    this.onSuccess,
  });

  final String label;
  final String? nombreArchivo;
  final String? mensaje;

  /// Contenido a compartir (p. ej. PDF). Si es null, usa archivo de prueba.
  final Uint8List? bytes;
  final String mimeType;

  final bool enabled;
  final bool expanded;
  final double height;

  /// Permite inyectar el servicio (útil en tests).
  final WhatsAppShareService? service;

  final void Function(Object error)? onError;
  final VoidCallback? onSuccess;

  @override
  State<BotonWhatsAppShare> createState() => _BotonWhatsAppShareState();
}

class _BotonWhatsAppShareState extends State<BotonWhatsAppShare> {
  late final WhatsAppShareService _service =
      widget.service ?? WhatsAppShareService();

  bool _loading = false;

  Future<void> _onPressed() async {
    if (_loading || !widget.enabled) return;

    setState(() => _loading = true);
    try {
      final bytes = widget.bytes;
      if (bytes != null && bytes.isNotEmpty) {
        await _service.compartirBytes(
          bytes: bytes,
          nombreArchivo: widget.nombreArchivo ?? 'documento.pdf',
          mimeType: widget.mimeType,
          mensaje: widget.mensaje,
        );
      } else {
        await _service.compartirArchivoDePrueba(
          nombreArchivo: widget.nombreArchivo,
          mensaje: widget.mensaje,
        );
      }
      widget.onSuccess?.call();
    } catch (e) {
      widget.onError?.call(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo compartir: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled && !_loading;

    return SizedBox(
      width: widget.expanded ? double.infinity : null,
      height: widget.height,
      child: Material(
        color: enabled ? kWhatsAppGreen : kWhatsAppGreen.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? _onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  widget.expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (_loading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.chat, size: 20, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _loading ? 'Preparando…' : widget.label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
