import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_spacing.dart';
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
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.receiptBg,
          // Radio propio del papel térmico: casi recto a propósito.
          borderRadius: BorderRadius.circular(4),
          boxShadow: AppShadows.floating,
          border: AppBorders.subtle,
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
