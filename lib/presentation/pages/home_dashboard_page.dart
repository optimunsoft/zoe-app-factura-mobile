import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_catalog.dart';
import '../../data/pos_controller.dart';
import '../../domain/models/sale_receipt.dart';
import '../molecules/dashboard_card.dart';
import '../molecules/printer_status_badge.dart';
import '../organisms/transaction_list.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({
    super.key,
    required this.onNewSale,
    required this.onDailySummary,
    required this.onInventory,
    required this.onReceipts,
    required this.onOpenReceipt,
  });

  final VoidCallback onNewSale;
  final VoidCallback onDailySummary;
  final VoidCallback onInventory;
  final VoidCallback onReceipts;
  final ValueChanged<SaleReceipt> onOpenReceipt;

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final user = context.watch<AuthController>().user;
    final report = MockCatalog.todayReport;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (user?.sucursalNombre ?? 'Sin sucursal').toUpperCase(),
              style: AppTextStyles.h2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              user?.fullName ?? '',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: PrinterStatusBadge(
                connected: pos.printerConnected,
                mode: pos.printerMode,
                onTap: pos.togglePrinter,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoy',
                        style: AppTextStyles.caption.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${report.totalSales.toStringAsFixed(2)}',
                        style: AppTextStyles.moneyXl.copyWith(color: Colors.white),
                      ),
                      Text(
                        '${report.invoiceCount} facturas · IVA \$${report.taxCollected.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.trending_up_rounded, color: Colors.white, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Accesos rápidos', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: [
              DashboardCard(
                title: 'Nueva venta',
                subtitle: 'Abrir catálogo POS',
                icon: Icons.add_shopping_cart_rounded,
                onTap: onNewSale,
              ),
              DashboardCard(
                title: 'Resumen diario',
                subtitle: 'Z-Report del día',
                icon: Icons.summarize_rounded,
                accent: AppColors.success,
                onTap: onDailySummary,
              ),
              DashboardCard(
                title: 'Inventario',
                subtitle: 'Stock en ruta',
                icon: Icons.inventory_2_rounded,
                accent: AppColors.warning,
                onTap: onInventory,
              ),
              DashboardCard(
                title: 'Tickets recientes',
                subtitle: 'Últimas facturas',
                icon: Icons.receipt_long_rounded,
                accent: AppColors.primaryDark,
                onTap: onReceipts,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: Text('Recibos recientes', style: AppTextStyles.h3)),
              TextButton(
                onPressed: onReceipts,
                child: Text('Ver todos', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TransactionList(
            transactions: MockCatalog.recentSales.take(3).toList(),
            onTap: onOpenReceipt,
          ),
        ],
      ),
    );
  }
}
