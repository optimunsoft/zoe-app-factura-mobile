import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_toast.dart';
import '../../../../core/services/whatsapp_share_service.dart';
import '../../../../modules/sales/domain/models/ingresos_medios_pago.models.dart';
import '../../../../modules/sales/store/sales.store.dart';
import '../../../atoms/app_button.dart';

/// Descarga el PDF del reporte de ingresos por medios de pago.
class BotonDescargarPdfMediosPago extends StatefulWidget {
  const BotonDescargarPdfMediosPago({super.key, required this.query});

  final IngresosMediosPagoQuery query;

  @override
  State<BotonDescargarPdfMediosPago> createState() =>
      _BotonDescargarPdfMediosPagoState();
}

class _BotonDescargarPdfMediosPagoState
    extends State<BotonDescargarPdfMediosPago> {
  bool _localBusy = false;

  bool get _queryOk {
    return widget.query.branchId.trim().isNotEmpty &&
        widget.query.startDate.trim().isNotEmpty &&
        widget.query.endDate.trim().isNotEmpty;
  }

  String get _fileName {
    final start = widget.query.startDate.trim();
    final end = widget.query.endDate.trim();
    return 'ingresos-medios-pago_$start-$end.pdf';
  }

  Future<void> _onPressed() async {
    if (_localBusy || !_queryOk) return;

    setState(() => _localBusy = true);
    final store = context.read<SalesStore>();

    try {
      final bytes = await store.downloadIngresosMediosPagoPdf(widget.query);
      if (!mounted) return;

      if (bytes == null || bytes.isEmpty) {
        final message = store.ingresosMediosPagoPdfError?.trim();
        AppToast.error(
          (message != null && message.isNotEmpty)
              ? message
              : 'No se pudo descargar el PDF',
        );
        return;
      }

      await WhatsAppShareService().compartirBytes(
        bytes: bytes,
        nombreArchivo: _fileName,
        mimeType: 'application/pdf',
        mensaje: 'Reporte de ingresos por medios de pago',
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
    final busy = _localBusy || store.isDownloadingIngresosMediosPagoPdf;
    final enabled = _queryOk && !busy;

    return AppButton(
      label: busy ? 'Descargando…' : 'Descargar PDF',
      icon: busy ? null : Icons.picture_as_pdf_rounded,
      variant: AppButtonVariant.secondary,
      onPressed: enabled ? _onPressed : null,
    );
  }
}
