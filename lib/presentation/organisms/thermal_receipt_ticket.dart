import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/payment_method.dart';
import '../../domain/models/sale_receipt.dart';
import '../atoms/money_text.dart';

class ThermalReceiptTicket extends StatelessWidget {
  const ThermalReceiptTicket({
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
            _dashed(),
            const SizedBox(height: 8),
            _line('Orden', receipt.orderId),
            _line('Fecha', dateFmt.format(receipt.timestamp)),
            _line('Pago', receipt.paymentMethod.label),
            const SizedBox(height: 8),
            _dashed(),
            const SizedBox(height: 8),
            ...receipt.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: AppTextStyles.receipt.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity} x ${item.product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.receipt,
                          ),
                        ),
                        MoneyText(
                          item.lineTotal,
                          style: AppTextStyles.receipt.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _dashed(),
            const SizedBox(height: 8),
            _moneyLine('Subtotal', receipt.subtotal),
            _moneyLine('IVA (16%)', receipt.tax),
            if (receipt.discount > 0) _moneyLine('Descuentos', -receipt.discount),
            const SizedBox(height: 4),
            _moneyLine('TOTAL', receipt.total, bold: true),
            if (receipt.cashReceived != null) ...[
              const SizedBox(height: 6),
              _moneyLine('Recibido', receipt.cashReceived!),
              _moneyLine('Cambio', receipt.changeDue ?? 0),
            ],
            const SizedBox(height: 14),
            _dashed(),
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
        ),
      ),
    );
  }

  Widget _dashed() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        final count = (constraints.maxWidth / (dashWidth * 1.6)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              color: AppColors.receiptLine.withValues(alpha: 0.55),
            ),
          ),
        );
      },
    );
  }

  Widget _line(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(k, style: AppTextStyles.receipt)),
          Text(v, style: AppTextStyles.receipt.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _moneyLine(String k, num v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: AppTextStyles.receipt.copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                fontSize: bold ? 13 : 11,
              ),
            ),
          ),
          MoneyText(
            v,
            style: AppTextStyles.receipt.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: bold ? 13 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
