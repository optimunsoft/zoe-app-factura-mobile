import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock_catalog.dart';
import '../../../domain/models/sale_receipt.dart';
import '../../atoms/app_button.dart';
import 'widgets/reports_summary_cards.dart';
import '../../organisms/transaction_list.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({
    super.key,
    required this.onOpenReceipt,
  });

  final ValueChanged<SaleReceipt> onOpenReceipt;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  DateTime _date = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE d MMM yyyy', 'es').format(_date);
    final isToday = DateUtils.isSameDay(_date, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas e inventario', style: AppTextStyles.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Filtro de fecha', style: AppTextStyles.caption),
                          Text(
                            isToday ? 'Hoy · $dateLabel' : dateLabel,
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.expand_more_rounded),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ReportsSummaryCards(report: MockCatalog.todayReport),
          const SizedBox(height: 18),
          AppButton(
            label: 'Imprimir resumen Z-Report',
            icon: Icons.print_rounded,
            onPressed: () => _snack('Imprimiendo Z-Report del día…'),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Imprimir stock en mano',
            icon: Icons.inventory_2_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: () => _snack('Imprimiendo reporte de inventario…'),
          ),
          const SizedBox(height: 22),
          Text('Transacciones recientes', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          TransactionList(
            transactions: MockCatalog.recentSales,
            onTap: widget.onOpenReceipt,
          ),
        ],
      ),
    );
  }
}
