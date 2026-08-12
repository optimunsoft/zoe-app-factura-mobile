import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/sale_receipt.dart';
import '../../../atoms/money_text.dart';

/// Líneas de productos del ticket térmico.
class LineasTicket extends StatelessWidget {
  const LineasTicket({super.key, required this.receipt});

  final SaleReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
