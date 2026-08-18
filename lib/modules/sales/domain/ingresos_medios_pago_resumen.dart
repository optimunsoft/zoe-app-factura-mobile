import 'models/ingresos_medios_pago.models.dart';

/// Total acumulado de un medio de pago en el reporte.
class TotalMedioPago {
  const TotalMedioPago({
    required this.paymentMethodId,
    required this.name,
    required this.amount,
    required this.lineCount,
  });

  final int paymentMethodId;
  final String name;
  final double amount;
  final int lineCount;
}

/// Totales derivados del listado de ingresos por medios de pago.
class IngresosMediosPagoResumen {
  const IngresosMediosPagoResumen({
    required this.totalesPorMedio,
    required this.totalIngresos,
    required this.cantidadVentas,
    required this.ventasSinDesglose,
  });

  final List<TotalMedioPago> totalesPorMedio;
  final double totalIngresos;
  final int cantidadVentas;
  final int ventasSinDesglose;

  static const empty = IngresosMediosPagoResumen(
    totalesPorMedio: [],
    totalIngresos: 0,
    cantidadVentas: 0,
    ventasSinDesglose: 0,
  );

  factory IngresosMediosPagoResumen.fromItems(
    List<IngresoMedioPagoItem> items,
  ) {
    final map = <int, TotalMedioPago>{};
    var sinDesglose = 0;

    for (final item in items) {
      if (item.paymentDetails.isEmpty) {
        sinDesglose++;
        continue;
      }
      for (final line in item.paymentDetails) {
        final prev = map[line.paymentMethodId];
        map[line.paymentMethodId] = TotalMedioPago(
          paymentMethodId: line.paymentMethodId,
          name: line.name.isNotEmpty
              ? line.name
              : (prev?.name.isNotEmpty == true
                  ? prev!.name
                  : 'Medio ${line.paymentMethodId}'),
          amount: (prev?.amount ?? 0) + line.amount,
          lineCount: (prev?.lineCount ?? 0) + 1,
        );
      }
    }

    final totales = map.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final total = totales.fold<double>(0, (sum, t) => sum + t.amount);

    return IngresosMediosPagoResumen(
      totalesPorMedio: totales,
      totalIngresos: total,
      cantidadVentas: items.length,
      ventasSinDesglose: sinDesglose,
    );
  }
}
