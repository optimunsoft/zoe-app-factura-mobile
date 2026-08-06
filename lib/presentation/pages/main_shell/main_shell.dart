import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/sale_receipt.dart';
import '../../organisms/app_bottom_nav.dart';
import '../checkout/checkout_page.dart';
import '../home_dashboard/home_dashboard_page.dart';
import '../pos_sale_flow/pos_sale_flow_page.dart';
import '../receipt_preview/receipt_preview_page.dart';
import '../receipts_list/receipts_list_page.dart';
import '../reports/reports_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  void _goTab(int i) => setState(() => _tab = i);

  void _startSaleFlow() {
    context.read<PosController>().startNewSale();
    _goTab(1);
  }

  Future<bool> _confirmLeaveSale() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text(
          'Se perderá la venta en curso. El cliente y los productos seleccionados se borrarán.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sí, salir'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _onTabChanged(int i) async {
    final pos = context.read<PosController>();
    final hasSaleInProgress =
        pos.itemCount > 0 || pos.activeCustomer != null;

    // Venta → Inicio con cliente y/o productos seleccionados.
    if (_tab == 1 && i == 0 && hasSaleInProgress) {
      final ok = await _confirmLeaveSale();
      if (!ok || !mounted) return;
      pos.startNewSale();
    }

    if (i == 1 && _tab != 1) {
      // Entrar al módulo POS desde otra pestaña → flujo desde cliente
      pos.startNewSale();
    }
    _goTab(i);
  }

  Future<void> _openCheckout() async {
    final pos = context.read<PosController>();
    if (pos.itemCount == 0) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          onCompleted: () {
            Navigator.of(context).pop();
            final receipt = context.read<PosController>().lastReceipt;
            if (receipt != null) _openReceipt(receipt, fromCheckout: true);
          },
        ),
      ),
    );
  }

  Future<void> _openReceipt(SaleReceipt receipt, {bool fromCheckout = false}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReceiptPreviewPage(
          receipt: receipt,
          onNewSale: () {
            Navigator.of(context).pop();
            _startSaleFlow();
          },
          onDone: () {
            Navigator.of(context).pop();
            if (fromCheckout) _goTab(0);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDashboardPage(
        onNewSale: _startSaleFlow,
        onDailySummary: () => _goTab(3),
        onInventory: () => _goTab(3),
        onReceipts: () => _goTab(2),
        onOpenReceipt: _openReceipt,
      ),
      PosSaleFlowPage(onReviewPay: _openCheckout),
      ReceiptsListPage(onOpenReceipt: _openReceipt),
      ReportsPage(onOpenReceipt: _openReceipt),
    ];

    return Scaffold(
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: AppBottomNav(
        index: _tab,
        onChanged: _onTabChanged,
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: _startSaleFlow,
              icon: const Icon(Icons.point_of_sale_rounded),
              label: const Text('Vender'),
            )
          : null,
    );
  }
}
