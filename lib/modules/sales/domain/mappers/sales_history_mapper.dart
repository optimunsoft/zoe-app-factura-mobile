import 'package:intl/intl.dart';

import '../models/list_sales.models.dart';
import '../models/sales_history_item.dart';

/// Mapper API → view models del historial.
abstract final class SalesHistoryMapper {
  static final _timeFmt = DateFormat('HH:mm');
  static final _dateFmt = DateFormat('dd/MM/yyyy');

  static SaleHistoryItem toListItem(ListSales sale) {
    return SaleHistoryItem(
      id: sale.id,
      documentLabel: sale.documentNumber.isNotEmpty
          ? sale.documentNumber
          : 'Venta #${sale.id}',
      customerName:
          sale.thirdPartyName.isNotEmpty ? sale.thirdPartyName : 'Sin cliente',
      subtitle: _buildSubtitle(sale),
      total: sale.saleTotalValue,
    );
  }

  static List<SaleHistoryItem> toListItems(List<ListSales> sales) {
    return sales.map(toListItem).toList(growable: false);
  }

  static String _buildSubtitle(ListSales sale) {
    final parsed = DateTime.tryParse(sale.saleDate)?.toLocal();
    final timePart = parsed != null ? _timeFmt.format(parsed) : '';
    final datePart = parsed != null ? _dateFmt.format(parsed) : '';
    final payment = sale.paymentForm.isNotEmpty
        ? sale.paymentForm
        : (sale.paymentDetails.isNotEmpty
            ? sale.paymentDetails.map((p) => p.name).join(' + ')
            : '');

    final parts = <String>[
      if (datePart.isNotEmpty) datePart,
      if (timePart.isNotEmpty) timePart,
      if (payment.isNotEmpty) payment,
    ];
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  /// Primera letra en mayúscula, resto en minúscula (por palabra).
  static String toTitleCase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          final lower = word.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }

  static String formatDateTime(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.isEmpty ? '—' : raw;
    return DateFormat('dd/MM/yyyy HH:mm').format(parsed.toLocal());
  }
}
