import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/layout/ancho_vista.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/sales/domain/models/sales_history_filters.dart';
import '../../../modules/sales/store/sales_history.store.dart';
import '../../atoms/boton_menu_drawer.dart';
import '../../molecules/barra_filtros_activos.dart';
import '../../molecules/contenido_ancho_maximo.dart';
import '../../organisms/plantilla_adaptativa.dart';
import 'widgets/lista_historial_ventas.dart';
import 'widgets/sheet_detalle_venta.dart';
import 'widgets/sheet_filtros_historial_ventas.dart';

/// Pantalla principal del historial de ventas.
class HistorialVentasPage extends StatefulWidget {
  const HistorialVentasPage({super.key});

  @override
  State<HistorialVentasPage> createState() => _HistorialVentasPageState();
}

class _HistorialVentasPageState extends State<HistorialVentasPage> {
  static final _dateFmt = DateFormat('dd/MM/yyyy');
  int? _ventaSeleccionadaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  String? get _branchId {
    final id = context.read<AuthController>().user?.sucursalId;
    return id == null ? null : '$id';
  }

  Future<void> _load({SalesHistoryFilters? filters}) {
    return context.read<SalesHistoryStore>().load(
          branchId: _branchId,
          filters: filters,
        );
  }

  Future<void> _openFilters() async {
    final store = context.read<SalesHistoryStore>();
    final result = await SheetFiltrosHistorialVentas.show(
      context,
      initial: store.filters,
    );
    if (result == null || !mounted) return;
    await _load(filters: result);
  }

  void _clearFilters() {
    final cleared = SalesHistoryFilters();
    _load(filters: cleared);
  }

  List<ChipFiltroActivo> _activeChips(SalesHistoryFilters filters) {
    final chips = <ChipFiltroActivo>[];
    final doc = filters.documentNumber.trim();
    if (doc.isNotEmpty) {
      chips.add(ChipFiltroActivo(
        label: 'Doc: $doc',
        onClear: () {
          final next = filters.copy()..documentNumber = '';
          _load(filters: next);
        },
      ));
    }
    if (filters.startDate != null) {
      chips.add(ChipFiltroActivo(
        label: 'Desde ${_dateFmt.format(filters.startDate!)}',
        onClear: () {
          final next = filters.copy()..startDate = null;
          _load(filters: next);
        },
      ));
    }
    if (filters.endDate != null) {
      chips.add(ChipFiltroActivo(
        label: 'Hasta ${_dateFmt.format(filters.endDate!)}',
        onClear: () {
          final next = filters.copy()..endDate = null;
          _load(filters: next);
        },
      ));
    }
    if (filters.thirdPartyName != null &&
        filters.thirdPartyName!.isNotEmpty) {
      chips.add(ChipFiltroActivo(
        label: filters.thirdPartyName!,
        onClear: () {
          final next = filters.copy()
            ..thirdPartyId = null
            ..thirdPartyName = null;
          _load(filters: next);
        },
      ));
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SalesHistoryStore>();
    final chips = _activeChips(store.filters);
    final padding = AnchoVista.paddingPagina(context);
    final dosColumnas = AnchoVista.usaDosColumnas(context);

    final lista = RefreshIndicator(
      onRefresh: () => _load(),
      child: ContenidoAnchoMaximo(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          children: [
            BarraFiltrosActivos(
              chips: chips,
              onClearAll: _clearFilters,
            ),
            ListaHistorialVentas(
              selectedId: dosColumnas ? _ventaSeleccionadaId : null,
              onSeleccionar: dosColumnas
                  ? (item) => setState(() => _ventaSeleccionadaId = item.id)
                  : null,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: BotonMenuDrawer.anchoLeading,
        leading: const BotonMenuDrawer(),
        title: Text('Historial de ventas', style: AppTextStyles.h2),
        actions: [
          IconButton(
            tooltip: 'Filtros',
            onPressed: _openFilters,
            icon: Badge(
              isLabelVisible: store.filters.hasActiveFilters,
              smallSize: 8,
              child: const Icon(Icons.tune_rounded),
            ),
          ),
        ],
      ),
      body: PlantillaDosColumnas(
        principal: lista,
        detalle: _ventaSeleccionadaId == null
            ? Center(
                child: Text(
                  'Selecciona una venta',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              )
            : SheetDetalleVenta(
                key: ValueKey(_ventaSeleccionadaId),
                saleId: _ventaSeleccionadaId!,
              ),
      ),
    );
  }
}

/// Alias legacy para compatibilidad con rutas existentes.
typedef SalesHistoryPage = HistorialVentasPage;
typedef ReceiptsListPage = HistorialVentasPage;
