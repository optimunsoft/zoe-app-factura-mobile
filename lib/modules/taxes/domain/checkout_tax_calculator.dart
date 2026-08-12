import '../../../core/utils/currency_format.dart';
import '../../../data/pos_controller.dart';
import 'models/taxes.models.dart';

/// Cálculos compartidos de retenciones en Resumen de venta / Medios de pago.
///
/// Alineado a totales DIAN (`DashboardEmitir`):
/// - reteIVA = totalIVA × (porcentaje / factor)   // factor default 100
/// - reteICA = Σ base_imponible × (porcentaje / factor)  // factor default 1000
/// - totalNeto = subtotal − reteICA − reteIVA − Σ retenciones_de_línea
abstract final class CheckoutTaxCalculator {
  static TaxRetention? findById(List<TaxRetention> options, int? id) {
    if (id == null) return null;
    for (final item in options) {
      if (item.id == id) return item;
    }
    return null;
  }

  /// Base IVA (suma de líneas IVA del breakdown del POS).
  static double ivaBase(PosController pos) {
    return pos.taxBreakdown
        .where((t) => t.isIva)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// reteIVA = totalIVA × (porcentaje_reteIVA / factor).
  static double reteIvaAmount(PosController pos, TaxRetention? selected) {
    return selected?.amountOn(ivaBase(pos)) ?? 0;
  }

  /// reteICA = Σ base_imponible × (porcentaje_reteICA / factor).
  static double reteIcaAmount(PosController pos, TaxRetention? selected) {
    return selected?.amountOn(pos.taxableBaseTotal) ?? 0;
  }

  /// Total a cubrir con medios de pago después de retenciones (= totalNeto).
  static double amountDue(
    PosController pos, {
    required TaxRetention? reteIva,
    required TaxRetention? reteIca,
    required double reteFuente,
    bool round = true,
  }) {
    final raw = pos.total -
        reteIvaAmount(pos, reteIva) -
        reteIcaAmount(pos, reteIca) -
        reteFuente;
    final net = round ? CurrencyFormat.roundMoney(raw) : raw;
    return net < 0 ? 0 : net;
  }

  static String formatPct(num value) {
    final d = value.toDouble();
    if (d == d.roundToDouble()) return '${d.toInt()}';
    return d.toStringAsFixed(2);
  }
}
