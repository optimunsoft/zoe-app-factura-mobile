import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../molecules/summary_row.dart';

class CheckoutSummaryCard extends StatelessWidget {
  const CheckoutSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  });

  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          SummaryRow(label: 'Subtotal', value: subtotal),
          SummaryRow(label: 'IVA (16%)', value: tax),
          SummaryRow(label: 'Descuentos', value: -discount),
          const Divider(height: 20),
          SummaryRow(
            label: 'Total final',
            value: total,
            emphasize: true,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
