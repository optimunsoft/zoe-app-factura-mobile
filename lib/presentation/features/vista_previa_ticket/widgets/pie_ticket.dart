import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'utilidades_ticket.dart';

/// Pie del ticket térmico: código de barras, QR y mensaje de agradecimiento.
class PieTicket extends StatelessWidget {
  const PieTicket({super.key, required this.widthMm});

  final int widthMm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        const TicketDivisor(),
        const SizedBox(height: 14),
        Container(
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.receiptLine),
          ),
          child: Text(
            '|| ||| |||| | || ||| |||| ||',
            style: AppTextStyles.receipt.copyWith(letterSpacing: 1.2),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.receiptLine),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.qr_code_2, size: 56),
        ),
        const SizedBox(height: 10),
        Text(
          '¡Gracias por su compra!',
          style: AppTextStyles.receipt.copyWith(fontWeight: FontWeight.w700),
        ),
        Text('${widthMm}mm thermal', style: AppTextStyles.receipt),
      ],
    );
  }
}
