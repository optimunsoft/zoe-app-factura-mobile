/// View model de una fila del historial (desacoplado del JSON de API).
class SaleHistoryItem {
  const SaleHistoryItem({
    required this.id,
    required this.documentLabel,
    required this.customerName,
    required this.subtitle,
    required this.total,
  });

  final int id;
  final String documentLabel;
  final String customerName;
  final String subtitle;
  final double total;
}
