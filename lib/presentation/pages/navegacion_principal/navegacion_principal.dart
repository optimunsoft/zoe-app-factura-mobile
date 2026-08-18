import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/sale_receipt.dart';
import '../../features/historial_ventas/historial_ventas_page.dart';
import '../../features/revisar_venta/revisar_venta_page.dart';
import '../../features/vista_previa_ticket/vista_previa_ticket_page.dart';
import '../../organisms/control_drawer_app.dart';
import '../../organisms/dialogo_cerrar_sesion.dart';
import '../../organisms/drawer_navegacion.dart';
import '../../organisms/nav_inferior_app.dart';
import '../inicio/inicio_page.dart';
import '../reportes/reportes_page.dart';
import '../venta/venta_page.dart';

class NavegacionPrincipal extends StatefulWidget {
  const NavegacionPrincipal({super.key});

  @override
  State<NavegacionPrincipal> createState() => _NavegacionPrincipalState();
}

class _NavegacionPrincipalState extends State<NavegacionPrincipal> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    if (i == _tab) return;

    final pos = context.read<PosController>();
    final hasSaleInProgress = pos.itemCount > 0 || pos.activeCustomer != null;

    // Saliendo de Venta (Inicio / Facturas / Reportes) con proceso en curso.
    if (_tab == 1 && i != 1 && hasSaleInProgress) {
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
        builder: (_) => RevisarVentaPage(
          onCompleted: () {
            Navigator.of(context).pop();
            final receipt = context.read<PosController>().lastReceipt;
            if (receipt != null) _openReceipt(receipt, fromCheckout: true);
          },
        ),
      ),
    );
  }

  Future<void> _openReceipt(
    SaleReceipt receipt, {
    bool fromCheckout = false,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VistaPreviaTicketPage(
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
      InicioPage(
        onNewSale: _startSaleFlow,
        onReceipts: () => _goTab(2),
        onReports: () => _goTab(3),
      ),
      VentaPage(onReviewPay: _openCheckout),
      const HistorialVentasPage(),
      const ReportesPage(),
    ];

    return ControlDrawerApp(
      openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerNavegacion(
          onLogout: () => confirmarCerrarSesion(context),
        ),
        body: IndexedStack(index: _tab, children: pages),
        bottomNavigationBar: NavInferiorApp(
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
      ),
    );
  }
}

/// Alias legacy — usar [NavegacionPrincipal].
typedef MainShell = NavegacionPrincipal;
