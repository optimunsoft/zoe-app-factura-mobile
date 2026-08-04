import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_customers.dart';
import '../../domain/models/customer.dart';
import '../atoms/app_button.dart';
import '../molecules/search_bar_with_scan.dart';
import '../organisms/customer_create_form.dart';
import '../organisms/customer_list.dart';

/// Pantalla 1 del flujo POS: buscar, seleccionar o crear cliente.
class CustomerSelectionPage extends StatefulWidget {
  const CustomerSelectionPage({
    super.key,
    required this.onCustomerSelected,
  });

  final ValueChanged<Customer> onCustomerSelected;

  @override
  State<CustomerSelectionPage> createState() => _CustomerSelectionPageState();
}

class _CustomerSelectionPageState extends State<CustomerSelectionPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _creating = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _select(Customer customer) {
    widget.onCustomerSelected(customer);
  }

  void _create(Customer draft) {
    final created = MockCustomers.add(draft);
    _select(created);
  }

  @override
  Widget build(BuildContext context) {
    final results = MockCustomers.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _creating ? 'Nuevo cliente' : 'Seleccionar cliente',
          style: AppTextStyles.h2,
        ),
        leading: _creating
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _creating = false),
              )
            : null,
        automaticallyImplyLeading: _creating,
      ),
      body: _creating
          ? CustomerCreateForm(onSubmit: _create)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SearchBarWithScan(
                    controller: _searchCtrl,
                    hint: 'Buscar por nombre, NIT o teléfono…',
                    onChanged: (v) => setState(() => _query = v),
                    onScan: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Escáner de documento (simulado)'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppButton(
                    label: 'Crear cliente nuevo',
                    icon: Icons.person_add_alt_1_rounded,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => setState(() => _creating = true),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomerList(
                    customers: results,
                    onSelect: _select,
                  ),
                ),
              ],
            ),
    );
  }
}
