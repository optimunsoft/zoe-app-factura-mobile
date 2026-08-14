import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/customer.dart';
import 'fila_cliente.dart';

class ListaClientes extends StatelessWidget {
  const ListaClientes({
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
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            'No se encontraron clientes',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return FilaCliente(
          customer: customer,
          onTap: () => onSelect(customer),
        );
      },
    );
  }
}

/// Alias legacy — usar [ListaClientes].
typedef CustomerList = ListaClientes;
