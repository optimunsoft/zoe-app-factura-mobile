import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/sale_receipt.dart';
import 'encabezado_ticket.dart';
import 'lineas_ticket.dart';
import 'pie_ticket.dart';
import 'totales_ticket.dart';

class TicketTermico extends StatelessWidget {
  const TicketTermico({
    super.key,
    required this.receipt,
    this.widthMm = 80,
  });

  final SaleReceipt receipt;
  final int widthMm;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final ticketWidth = widthMm == 58 ? 260.0 : 320.0;

    return Center(
      child: Container(
        width: ticketWidth,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        decoration: BoxDecoration(
          color: AppColors.receiptBg,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            EncabezadoTicket(receipt: receipt, dateFmt: dateFmt),
            LineasTicket(receipt: receipt),
            TotalesTicket(receipt: receipt),
            PieTicket(widthMm: widthMm),
          ],
        ),
      ),
    );
  }
}

/// Alias legacy — usar [TicketTermico].
typedef ThermalReceiptTicket = TicketTermico;
