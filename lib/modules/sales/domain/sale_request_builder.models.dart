import 'package:intl/intl.dart';

import '../../../data/pos_controller.dart';
import '../../../domain/models/cart_item.dart';
import '../../../domain/models/customer.dart';
import 'models/sales.models.dart';

/// Arma [CreateSaleRequest] desde el estado del POS (contado / forma 1).
abstract final class SaleRequestBuilder {
  static final DateFormat _dateFmt = DateFormat('yyyy-MM-dd HH:mm:ss');

  static CreateSaleRequest build({
    required PosController pos,
    required Customer customer,
    required int branchId,
    required String notes,
    required List<int> generalWithholdingIds,
    required Map<int, double> confirmedPayments,
    DateTime? at,
  }) {
    final customerId = int.tryParse(customer.id);
    if (customerId == null) {
      throw ArgumentError('id_cliente inválido: ${customer.id}');
    }

    final now = at ?? DateTime.now();
    final date = _dateFmt.format(now);

    return CreateSaleRequest(
      branchId: branchId,
      customerId: customerId,
      email: customer.email,
      date: date,
      dueDate: date,
      notes: notes,
      generalWithholdings: generalWithholdingIds,
      products: pos.cart.map(_mapProductLine).toList(),
      paymentDetail: SalePaymentDetail(
        paymentForm: '1',
        paymentMethods: confirmedPayments.entries
            .where((e) => e.value > 0)
            .map(
              (e) => SalePaymentMethodLine(
                paymentMethodId: e.key,
                amount: e.value,
              ),
            )
            .toList(),
        paymentDays: null,
      ),
      // Siempre sin restar retenciones: el backend las aplica con los IDs enviados.
      invoiceTotal: pos.total,
      purchaseOrder: '',
      dispatchOrder: '',
      receptionOrder: '',
    );
  }

  static SaleProductLine _mapProductLine(CartItem item) {
    final rawId = item.product.baseId ?? item.product.id;
    final productId = int.tryParse(rawId);
    if (productId == null) {
      throw ArgumentError('id de producto inválido: $rawId');
    }

    return SaleProductLine(
      id: productId,
      quantity: item.quantity,
      unitPrice: item.product.price.toStringAsFixed(2),
      description: item.product.name,
      discount: 0,
      taxes: item.product.taxes
          .map(
            (t) => SaleProductTax(
              name: t.name,
              code: t.code,
              percentage: t.percentage,
            ),
          )
          .toList(),
      withholdings:
          item.reteFuenteId != null ? <int>[item.reteFuenteId!] : const [],
    );
  }
}
