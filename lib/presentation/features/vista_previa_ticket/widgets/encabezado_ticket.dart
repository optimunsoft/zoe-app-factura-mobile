import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/payment_method.dart';
import '../../../../domain/models/sale_receipt.dart';
import 'utilidades_ticket.dart';

/// Encabezado del ticket térmico: logo, tienda y datos de la orden.
class EncabezadoTicket extends StatelessWidget {
  const EncabezadoTicket({
    super.key,
    required this.receipt,
    required this.dateFmt,
  });

  final SaleReceipt receipt;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.receiptLine, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            'LOGO',
            style: AppTextStyles.receipt.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'TIENDA A TIENDA',
          style: AppTextStyles.receipt.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text('Ruta campo · POS móvil', style: AppTextStyles.receipt),
        const SizedBox(height: 8),
        const TicketDivisor(),
        const SizedBox(height: 8),
        TicketLinea(label: 'Orden', value: receipt.orderId),
        TicketLinea(label: 'Fecha', value: dateFmt.format(receipt.timestamp)),
        TicketLinea(label: 'Pago', value: receipt.paymentMethod.label),
        const SizedBox(height: 8),
        const TicketDivisor(),
        const SizedBox(height: 8),
      ],
    );
  }
}
