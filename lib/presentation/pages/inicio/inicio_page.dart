import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../../modules/sales/domain/models/filtro_periodo_resumen.dart';
import '../../../modules/sales/store/sales.store.dart';
import '../../features/inicio/widgets/banner_ventas_hoy.dart';
import '../../features/inicio/widgets/grilla_accesos_rapidos.dart';
import '../../features/inicio/widgets/insignia_estado_impresora.dart';
import '../../features/inicio/widgets/sheet_filtro_periodo_resumen.dart';
import '../../features/reportes/widgets/tarjetas_resumen_reportes.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({
    super.key,
    required this.onNewSale,
    required this.onReceipts,
    required this.onReports,
  });

  final VoidCallback onNewSale;
  final VoidCallback onReceipts;
  final VoidCallback onReports;

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  FiltroPeriodoResumen _filtro = FiltroPeriodoResumen.anioActual;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadResumen());
  }

  Future<void> _loadResumen() async {
    final branchId = context.read<AuthController>().user?.sucursalId;
    if (branchId == null) {
      context.read<SalesStore>().clearResumen();
      return;
    }

    await context.read<SalesStore>().loadVentasResumen(
          _filtro.toQuery(branchId: '$branchId'),
        );
  }

  Future<void> _openPeriodFilter() async {
    final result = await SheetFiltroPeriodoResumen.show(
      context,
      initial: _filtro,
    );
    if (result == null || !mounted) return;
    setState(() => _filtro = result);
    await _loadResumen();
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final user = context.watch<AuthController>().user;
    final salesStore = context.watch<SalesStore>();

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
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: InsigniaEstadoImpresora(
                connected: pos.printerConnected,
                mode: pos.printerMode,
                onTap: pos.togglePrinter,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadResumen,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (user?.sucursalId == null)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'No se encontró la sucursal de la sesión',
                  style: TextStyle(color: AppColors.danger),
                ),
              )
            else if (salesStore.resumenError != null &&
                !salesStore.isLoadingResumen)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _loadResumen,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.danger,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              salesStore.resumenError!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                          Text(
                            'Reintentar',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            BannerVentasHoy(
              resumen: salesStore.resumen,
              isLoading: salesStore.isLoadingResumen,
              periodLabel: _filtro.displayLabel,
              onTap: user?.sucursalId == null ? null : _openPeriodFilter,
            ),
            const SizedBox(height: 16),
            TarjetasResumenReportes(
              resumen: salesStore.resumen,
              isLoading: salesStore.isLoadingResumen,
            ),
            const SizedBox(height: 18),
            GrillaAccesosRapidos(
              onNewSale: widget.onNewSale,
              onReceipts: widget.onReceipts,
              onReports: widget.onReports,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Salir',
              style: AppTextStyles.label.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    context.read<SalesStore>().clearResumen();
    context.read<PosController>().startNewSale();
    await context.read<AuthController>().logout();
  }
}

/// Alias legacy — usar [InicioPage].
typedef HomeDashboardPage = InicioPage;
