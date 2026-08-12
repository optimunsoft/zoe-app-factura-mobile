import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../domain/models/sale_receipt.dart';
import '../../../modules/sales/store/sales.store.dart';
import '../../atoms/app_button.dart';
import '../../atoms/whatsapp_share_button.dart';
import '../../molecules/cuerpo_error_reintentar.dart';
import '../../organisms/nav_inferior_app.dart';
import 'widgets/visor_pdf_documento.dart';

/// Ventana post-venta: visualiza el PDF del documento emitido.
class VistaPreviaTicketPage extends StatefulWidget {
  const VistaPreviaTicketPage({
    super.key,
    required this.receipt,
    required this.onNewSale,
    required this.onDone,
  });

  final SaleReceipt receipt;
  final VoidCallback onNewSale;
  final VoidCallback onDone;

  @override
  State<VistaPreviaTicketPage> createState() => _VistaPreviaTicketPageState();
}

class _VistaPreviaTicketPageState extends State<VistaPreviaTicketPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarPdf());
  }

  String get _nroDocumento => widget.receipt.orderId.trim();

  Future<void> _cargarPdf() async {
    final store = context.read<SalesStore>();
    await store.downloadSalePdf(_nroDocumento);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesStore>();
    final pdfListo = store.lastPdfBytes != null &&
        store.lastPdfDocumentNumber == _nroDocumento &&
        !store.isDownloadingPdf;

    return Scaffold(
      appBar: AppBar(
        title: Text('Documento de venta', style: AppTextStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            context.read<SalesStore>().clearPdf();
            widget.onDone();
          },
        ),
      ),
      body: _buildBody(store),
      bottomNavigationBar: BarraAccionFlotante(
        children: [
          BotonWhatsAppShare(
            label: 'Enviar por WhatsApp',
            enabled: pdfListo,
            bytes: pdfListo ? store.lastPdfBytes : null,
            nombreArchivo: '$_nroDocumento.pdf',
            mensaje:
                'Documento $_nroDocumento — Total: ${CurrencyFormat.money(widget.receipt.total)}',
          ),
          AppButton(
            label: 'Nueva venta',
            icon: Icons.add_shopping_cart_rounded,
            variant: AppButtonVariant.ghost,
            onPressed: () {
              context.read<SalesStore>().clearPdf();
              widget.onNewSale();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SalesStore store) {
    if (store.isDownloadingPdf) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text('Descargando documento…'),
          ],
        ),
      );
    }

    if (store.pdfError != null) {
      return CuerpoErrorReintentar(
        message: store.pdfError!,
        onRetry: _cargarPdf,
      );
    }

    final bytes = store.lastPdfBytes;
    if (bytes == null || bytes.isEmpty) {
      return CuerpoErrorReintentar(
        message: 'No hay PDF para mostrar',
        onRetry: _cargarPdf,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: VisorPdfDocumento(
        bytes: bytes,
        sourceName: '$_nroDocumento.pdf',
      ),
    );
  }
}

/// Alias legacy — usar [VistaPreviaTicketPage].
typedef ReceiptPreviewPage = VistaPreviaTicketPage;
