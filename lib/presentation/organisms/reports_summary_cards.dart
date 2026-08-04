import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/sale_receipt.dart';
import '../atoms/money_text.dart';

class ReportsSummaryCards extends StatelessWidget {
  const ReportsSummaryCards({super.key, required this.report});

  final DailyReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Ventas totales',
                icon: Icons.attach_money_rounded,
                child: MoneyText(report.totalSales, large: true, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                label: 'Facturas',
                icon: Icons.receipt_long_rounded,
                child: Text('${report.invoiceCount}', style: AppTextStyles.moneyLg),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'IVA recaudado',
                icon: Icons.account_balance_rounded,
                child: MoneyText(report.taxCollected, large: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                label: 'Efectivo / Digital',
                icon: Icons.pie_chart_outline_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MoneyText(report.cashAmount),
                    MoneyText(report.digitalAmount, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.child,
    required this.icon,
  });

  final String label;
  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: AppTextStyles.caption)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
