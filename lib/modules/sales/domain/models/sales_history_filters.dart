/// Filtros del historial de ventas (dominio, sin UI).
class SalesHistoryFilters {
  SalesHistoryFilters({
    this.documentNumber = '',
    this.startDate,
    this.endDate,
    this.thirdPartyId,
    this.thirdPartyName,
  });

  String documentNumber;
  DateTime? startDate;
  DateTime? endDate;
  String? thirdPartyId;
  String? thirdPartyName;

  bool get hasActiveFilters =>
      documentNumber.trim().isNotEmpty ||
      startDate != null ||
      endDate != null ||
      (thirdPartyId != null && thirdPartyId!.isNotEmpty);

  SalesHistoryFilters copy() => SalesHistoryFilters(
        documentNumber: documentNumber,
        startDate: startDate,
        endDate: endDate,
        thirdPartyId: thirdPartyId,
        thirdPartyName: thirdPartyName,
      );

  void clear() {
    documentNumber = '';
    startDate = null;
    endDate = null;
    thirdPartyId = null;
    thirdPartyName = null;
  }
}
