import 'package:flutter/material.dart';

/// Reporte que la app puede emitir. El [id] es la referencia con la que se
/// pide al backend.
class ReporteDisponible {
  const ReporteDisponible({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final IconData icono;
}

const ReporteDisponible kReporteIngresosMediosPago = ReporteDisponible(
  id: 'ingresos_medios_pago',
  nombre: 'Ingresos por medios de pago',
  descripcion: 'Ventas del periodo desglosadas por efectivo, transferencia y otros medios',
  icono: Icons.account_balance_wallet_outlined,
);

/// Catálogo de reportes disponibles en la pantalla de Reportes.
const List<ReporteDisponible> kReportesDisponibles = [
  kReporteIngresosMediosPago,
];
