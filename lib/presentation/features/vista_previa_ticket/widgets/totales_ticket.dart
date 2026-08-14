import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/models/sale_receipt.dart';
import 'utilidades_ticket.dart';

/// Totales, impuestos y cambio del ticket térmico.
class TotalesTicket extends StatelessWidget {
  const TotalesTicket({super.key, required this.receipt});

  final SaleReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TicketDivisor(),
        const SizedBox(height: AppSpacing.sm),
        TicketLineaMonto(label: 'Subtotal', amount: receipt.subtotal),
        if (receipt.taxBreakdown.isEmpty)
          TicketLineaMonto(label: 'Impuestos', amount: receipt.tax)
        else
          ...receipt.taxBreakdown.map(
            (t) => TicketLineaMonto(label: t.label, amount: t.amount),
          ),
        if (receipt.discount > 0)
          TicketLineaMonto(label: 'Descuentos', amount: -receipt.discount),
        const SizedBox(height: AppSpacing.xs),
        TicketLineaMonto(label: 'TOTAL', amount: receipt.total, bold: true),
        if (receipt.cashReceived != null) ...[
          const SizedBox(height: AppSpacing.sm),
          TicketLineaMonto(label: 'Recibido', amount: receipt.cashReceived!),
          TicketLineaMonto(label: 'Cambio', amount: receipt.changeDue ?? 0),
        ],
      ],
    );
  }
}
