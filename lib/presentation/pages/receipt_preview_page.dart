import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/sale_receipt.dart';
import '../atoms/app_button.dart';
import '../organisms/app_bottom_nav.dart';
import '../organisms/thermal_receipt_ticket.dart';

class ReceiptPreviewPage extends StatefulWidget {
  const ReceiptPreviewPage({
    super.key,
    required this.receipt,
    required this.onNewSale,
    required this.onDone,
  });

  final SaleReceipt receipt;
  final VoidCallback onNewSale;
  final VoidCallback onDone;

  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage> {
  int _widthMm = 80;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista previa ticket', style: AppTextStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: widget.onDone,
        ),
        actions: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 58, label: Text('58mm')),
              ButtonSegment(value: 80, label: Text('80mm')),
            ],
            selected: {_widthMm},
            onSelectionChanged: (s) => setState(() => _widthMm = s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStatePropertyAll(AppTextStyles.caption),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ThermalReceiptTicket(receipt: widget.receipt, widthMm: _widthMm),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: FloatingActionBar(
        children: [
          AppButton(
            label: 'Imprimir ticket térmico',
            icon: Icons.print_rounded,
            onPressed: () => _snack('Enviado a impresora térmica ($_widthMm mm)'),
          ),
          AppButton(
            label: 'Enviar por WhatsApp',
            icon: Icons.chat_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: () => _snack('Compartir recibo por WhatsApp…'),
          ),
          AppButton(
            label: 'Nueva venta',
            icon: Icons.add_shopping_cart_rounded,
            variant: AppButtonVariant.ghost,
            onPressed: widget.onNewSale,
          ),
        ],
      ),
    );
  }
}
