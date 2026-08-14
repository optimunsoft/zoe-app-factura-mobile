import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../atoms/app_button.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
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
        title: Text('Reportes', style: AppTextStyles.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            child: InkWell(
              onTap: _pickDate,
              borderRadius: AppRadius.mdAll,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: AppBorders.subtle,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Imprimir resumen Z-Report',
            icon: Icons.print_rounded,
            onPressed: () => _snack('Imprimiendo Z-Report del día…'),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Imprimir stock en mano',
            icon: Icons.inventory_2_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: () => _snack('Imprimiendo reporte de inventario…'),
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [ReportesPage].
typedef ReportsPage = ReportesPage;
