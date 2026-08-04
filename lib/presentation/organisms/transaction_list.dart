import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/payment_method.dart';
import '../../domain/models/sale_receipt.dart';
import '../atoms/money_text.dart';
import '../molecules/status_tag.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    this.onTap,
  });

  final List<SaleReceipt> transactions;
  final ValueChanged<SaleReceipt>? onTap;

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    return Column(
      children: transactions.map((tx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTap == null ? null : () => onTap!(tx),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx.orderId, style: AppTextStyles.label),
                          const SizedBox(height: 2),
                          Text(
                            '${timeFmt.format(tx.timestamp)} · ${tx.paymentMethod.label}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MoneyText(tx.total),
                        const SizedBox(height: 4),
                        StatusTag(status: tx.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
