import 'package:flutter/material.dart';

import '../../../core/layout/ancho_vista.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../atoms/boton_menu_drawer.dart';
import '../../features/reportes/reporte_medios_pago_page.dart';
import '../../features/reportes/reportes_catalogo.dart';
import '../../features/reportes/widgets/tarjeta_reporte.dart';
import '../../molecules/contenido_ancho_maximo.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({super.key});

  void _abrirReporte(BuildContext context, ReporteDisponible reporte) {
    if (reporte.id == kReporteIngresosMediosPago.id) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ReporteMediosPagoPage()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: BotonMenuDrawer.anchoLeading,
        leading: const BotonMenuDrawer(),
        title: Text('Reportes', style: AppTextStyles.h2),
      ),
      body: ContenidoAnchoMaximo(
        child: ListView.separated(
          padding: AnchoVista.paddingPagina(
            context,
            top: AppSpacing.lg,
            bottom: AppSpacing.xl,
          ),
        itemCount: kReportesDisponibles.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final reporte = kReportesDisponibles[index];
          return TarjetaReporte(
            reporte: reporte,
            onTap: () => _abrirReporte(context, reporte),
          );
        },
        ),
      ),
    );
  }
}

/// Alias legacy — usar [ReportesPage].
typedef ReportsPage = ReportesPage;
