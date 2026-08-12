import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../features/inicio/widgets/banner_ventas_hoy.dart';
import '../../features/inicio/widgets/grilla_accesos_rapidos.dart';
import '../../features/inicio/widgets/insignia_estado_impresora.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({
    super.key,
    required this.onNewSale,
    required this.onDailySummary,
    required this.onInventory,
    required this.onReceipts,
  });

  final VoidCallback onNewSale;
  final VoidCallback onDailySummary;
  final VoidCallback onInventory;
  final VoidCallback onReceipts;

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final user = context.watch<AuthController>().user;

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const BannerVentasHoy(),
          const SizedBox(height: 18),
          GrillaAccesosRapidos(
            onNewSale: onNewSale,
            onDailySummary: onDailySummary,
            onInventory: onInventory,
            onReceipts: onReceipts,
          ),
        ],
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

    context.read<PosController>().startNewSale();
    await context.read<AuthController>().logout();
  }
}

/// Alias legacy — usar [InicioPage].
typedef HomeDashboardPage = InicioPage;
