import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/sales/domain/ingresos_medios_pago_resumen.dart';
import '../../../modules/sales/domain/models/ingresos_medios_pago.models.dart';
import '../../../modules/sales/store/sales.store.dart';
import '../../molecules/fila_rango_fechas.dart';
import 'widgets/boton_descargar_pdf_medios_pago.dart';
import 'widgets/linea_ingreso_venta.dart';
import 'widgets/resumen_medios_pago.dart';

/// Previsualización de GET /ventas/reportes/ingresos-medios-pago.
class ReporteMediosPagoPage extends StatefulWidget {
  const ReporteMediosPagoPage({super.key});

  @override
  State<ReporteMediosPagoPage> createState() => _ReporteMediosPagoPageState();
}

class _ReporteMediosPagoPageState extends State<ReporteMediosPagoPage> {
  static final _uiFmt = DateFormat('dd/MM/yyyy');
  static final _apiFmt = DateFormat('yyyy-MM-dd');

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  String? get _branchId {
    final id = context.read<AuthController>().user?.sucursalId;
    return id == null ? null : '$id';
  }

  Future<void> _load() async {
    final branchId = _branchId;
    if (branchId == null) {
      context.read<SalesStore>().clearIngresosMediosPago();
      return;
    }

    await context.read<SalesStore>().loadIngresosMediosPago(
          _queryFor(branchId)!,
        );
  }

  Future<void> _pickDate({required bool isStart}) async {
    if (_branchId == null) return;

    final today = DateTime.now();
    final firstDate = DateTime(today.year - 3, 1, 1);
    final lastDate = DateTime(today.year + 1, 12, 31);
    final initial = _clampDate(
      isStart ? _startDate : _endDate,
      firstDate,
      lastDate,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null || !mounted) return;

    final day = DateTime(picked.year, picked.month, picked.day);
    setState(() {
      if (isStart) {
        _startDate = day;
        if (_endDate.isBefore(_startDate)) _endDate = _startDate;
      } else {
        _endDate = day;
        if (_endDate.isBefore(_startDate)) _startDate = _endDate;
      }
    });
    await _load();
  }

  static DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
    if (value.isBefore(min)) return min;
    if (value.isAfter(max)) return max;
    return value;
  }

  IngresosMediosPagoQuery? _queryFor(String? branchId) {
    if (branchId == null) return null;
    return IngresosMediosPagoQuery(
      branchId: branchId,
      startDate: _apiFmt.format(_startDate),
      endDate: _apiFmt.format(_endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final store = context.watch<SalesStore>();
    final resumen = IngresosMediosPagoResumen.fromItems(
      store.ingresosMediosPago,
    );
    final canPick = user?.sucursalId != null;
    final query = _queryFor(_branchId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte por medios de pago', style: AppTextStyles.h2),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            if (user?.sucursalId == null)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'No se encontró la sucursal de la sesión',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            IgnorePointer(
              ignoring: !canPick,
              child: FilaRangoFechas(
                startLabel: 'Desde',
                endLabel: 'Hasta',
                startValue: _uiFmt.format(_startDate),
                endValue: _uiFmt.format(_endDate),
                onPickStart: () => _pickDate(isStart: true),
                onPickEnd: () => _pickDate(isStart: false),
              ),
            ),
            if (query != null) ...[
              const SizedBox(height: AppSpacing.md),
              BotonDescargarPdfMediosPago(query: query),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (store.isLoadingIngresosMediosPago)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (store.ingresosMediosPagoError != null)
              _ErrorCarga(
                message: store.ingresosMediosPagoError!,
                onRetry: _load,
              )
            else ...[
              ResumenMediosPago(resumen: resumen),
              const SizedBox(height: AppSpacing.xl),
              Text('Detalle de ventas', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),
              if (store.ingresosMediosPago.isEmpty)
                Text(
                  'No hay ventas en este periodo',
                  style: AppTextStyles.bodySmall,
                )
              else
                ...store.ingresosMediosPago.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: LineaIngresoVenta(item: item),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorCarga extends StatelessWidget {
  const _ErrorCarga({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerBg,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onRetry,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.danger,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message.isEmpty ? 'No se pudo cargar el reporte' : message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.danger,
                  ),
                ),
              ),
              Text(
                'Reintentar',
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
