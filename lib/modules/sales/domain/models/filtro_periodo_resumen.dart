import 'package:intl/intl.dart';

import 'ventas_resumen.models.dart';

/// Periodos predefinidos del resumen de ventas (inicio).
enum PeriodoResumenVentas {
  hoy,
  mesActual,
  anioActual,
  personalizado,
}

extension PeriodoResumenVentasX on PeriodoResumenVentas {
  String get label {
    switch (this) {
      case PeriodoResumenVentas.hoy:
        return 'Hoy';
      case PeriodoResumenVentas.mesActual:
        return 'Mes';
      case PeriodoResumenVentas.anioActual:
        return 'Año actual';
      case PeriodoResumenVentas.personalizado:
        return 'Personalizado';
    }
  }
}

/// Filtro de fechas para GET /ventas/resumen.
class FiltroPeriodoResumen {
  const FiltroPeriodoResumen({
    required this.periodo,
    this.startDate,
    this.endDate,
  });

  final PeriodoResumenVentas periodo;
  final DateTime? startDate;
  final DateTime? endDate;

  static final DateFormat _apiFmt = DateFormat('yyyy-MM-dd');
  static final DateFormat _uiFmt = DateFormat('dd/MM/yyyy');

  static FiltroPeriodoResumen get anioActual => const FiltroPeriodoResumen(
        periodo: PeriodoResumenVentas.anioActual,
      );

  FiltroPeriodoResumen copyWith({
    PeriodoResumenVentas? periodo,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStart = false,
    bool clearEnd = false,
  }) {
    return FiltroPeriodoResumen(
      periodo: periodo ?? this.periodo,
      startDate: clearStart ? null : (startDate ?? this.startDate),
      endDate: clearEnd ? null : (endDate ?? this.endDate),
    );
  }

  /// Rango efectivo (inicio/fin inclusive).
  ({DateTime start, DateTime end}) resolveRange({DateTime? now}) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);

    switch (periodo) {
      case PeriodoResumenVentas.hoy:
        return (start: today, end: today);
      case PeriodoResumenVentas.mesActual:
        final start = DateTime(n.year, n.month, 1);
        final end = DateTime(n.year, n.month + 1, 0); // último día del mes
        return (start: start, end: end);
      case PeriodoResumenVentas.anioActual:
        return (
          start: DateTime(n.year, 1, 1),
          end: DateTime(n.year, 12, 31),
        );
      case PeriodoResumenVentas.personalizado:
        final start = startDate ?? today;
        final end = endDate ?? start;
        final s = DateTime(start.year, start.month, start.day);
        final e = DateTime(end.year, end.month, end.day);
        return s.isAfter(e) ? (start: e, end: s) : (start: s, end: e);
    }
  }

  String get displayLabel {
    if (periodo != PeriodoResumenVentas.personalizado) {
      return periodo.label;
    }
    final range = resolveRange();
    return '${_uiFmt.format(range.start)} – ${_uiFmt.format(range.end)}';
  }

  VentasResumenQuery toQuery({required String branchId}) {
    final range = resolveRange();
    return VentasResumenQuery(
      startDate: _apiFmt.format(range.start),
      endDate: _apiFmt.format(range.end),
      branchId: branchId,
    );
  }
}
