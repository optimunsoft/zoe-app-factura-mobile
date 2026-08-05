import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/customer.dart';
import 'customer_list_tile.dart';

class CustomerList extends StatelessWidget {
  const CustomerList({
    super.key,
    required this.customers,
    required this.onSelect,
  });

  final List<Customer> customers;
  final ValueChanged<Customer> onSelect;

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No se encontraron clientes',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return CustomerListTile(
          customer: customer,
          onTap: () => onSelect(customer),
        );
      },
    );
  }
}
