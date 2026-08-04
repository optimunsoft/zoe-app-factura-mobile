import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/pos_controller.dart';
import 'customer_selection_page.dart';
import 'pos_catalog_page.dart';

/// Orquesta el flujo POS: Cliente → Catálogo.
class PosSaleFlowPage extends StatelessWidget {
  const PosSaleFlowPage({super.key, required this.onReviewPay});

  final VoidCallback onReviewPay;

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final customer = pos.activeCustomer;

    if (customer == null) {
      return CustomerSelectionPage(
        onCustomerSelected: pos.selectCustomer,
      );
    }

    return PosCatalogPage(
      onReviewPay: onReviewPay,
      onChangeCustomer: () {
        pos.clearCustomer();
      },
    );
  }
}
