import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_catalog.dart';
import '../../domain/models/sale_receipt.dart';
import '../organisms/transaction_list.dart';

class ReceiptsListPage extends StatelessWidget {
  const ReceiptsListPage({
    super.key,
    required this.onOpenReceipt,
  });

  final ValueChanged<SaleReceipt> onOpenReceipt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets recientes', style: AppTextStyles.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TransactionList(
            transactions: MockCatalog.recentSales,
            onTap: onOpenReceipt,
          ),
        ],
      ),
    );
  }
}
