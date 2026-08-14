import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_toast.dart';
import '../../../../core/services/whatsapp_share_service.dart';
import '../../../../modules/sales/store/sales.store.dart';
import '../../../atoms/app_button.dart';

/// Descarga el PDF de una venta y abre el menú nativo para guardar/compartir.
class BotonDescargarPdfVenta extends StatefulWidget {
  const BotonDescargarPdfVenta({
    super.key,
    required this.nroDocumento,
  });

  final String nroDocumento;

  @override
  State<BotonDescargarPdfVenta> createState() => _BotonDescargarPdfVentaState();
}

class _BotonDescargarPdfVentaState extends State<BotonDescargarPdfVenta> {
  bool _localBusy = false;

  String get _nro => widget.nroDocumento.trim();

  Future<void> _onPressed() async {
    if (_localBusy || _nro.isEmpty) return;

    setState(() => _localBusy = true);
    final store = context.read<SalesStore>();

    try {
      final bytes = await store.downloadSalePdf(_nro);
      if (!mounted) return;

      if (bytes == null || bytes.isEmpty) {
        final message = store.pdfError?.trim();
        AppToast.error(
          (message != null && message.isNotEmpty)
              ? message
              : 'No se pudo descargar el PDF',
        );
        return;
      }

      await WhatsAppShareService().compartirBytes(
        bytes: bytes,
        nombreArchivo: '$_nro.pdf',
        mimeType: 'application/pdf',
        mensaje: 'Documento $_nro',
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.error('No se pudo descargar el PDF');
    } finally {
      if (mounted) setState(() => _localBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesStore>();
    final downloadingThis = store.isDownloadingPdf &&
        store.lastPdfDocumentNumber == _nro;
    final busy = _localBusy || downloadingThis;
    final enabled = _nro.isNotEmpty && !busy;

    return AppButton(
      label: busy ? 'Descargando…' : 'Descargar PDF',
      icon: busy ? null : Icons.picture_as_pdf_rounded,
      variant: AppButtonVariant.secondary,
      onPressed: enabled ? _onPressed : null,
    );
  }
}
