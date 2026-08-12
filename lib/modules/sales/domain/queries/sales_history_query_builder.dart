import 'package:intl/intl.dart';

import '../models/list_sales.models.dart';
import '../models/sales_history_filters.dart';

/// Construye [ListSalesQuery] para el historial de ventas.
abstract final class SalesHistoryQueryBuilder {
  static const defaultPageSize = 10;

  static ListSalesQuery build({
    required SalesHistoryFilters filters,
    required String branchId,
    int page = 1,
    int pageSize = defaultPageSize,
  }) {
    final dateFmt = DateFormat('yyyy-MM-dd');
    return ListSalesQuery(
      page: '$page',
      amount: '$pageSize',
      branchId: branchId,
      documentNumber: filters.documentNumber.trim().isEmpty
          ? null
          : filters.documentNumber.trim(),
      startDate:
          filters.startDate == null ? null : dateFmt.format(filters.startDate!),
      endDate:
          filters.endDate == null ? null : dateFmt.format(filters.endDate!),
      thirdPartyId: filters.thirdPartyId,
    );
  }
}
