import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/customer.dart';
import '../atoms/app_button.dart';

/// Formulario mock para crear un cliente nuevo.
class CustomerCreateForm extends StatefulWidget {
  const CustomerCreateForm({super.key, required this.onSubmit});

  final ValueChanged<Customer> onSubmit;

  @override
  State<CustomerCreateForm> createState() => _CustomerCreateFormState();
}

class _CustomerCreateFormState extends State<CustomerCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _docCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _docType = 'CC';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _docCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      Customer(
        id: 'temp',
        name: _nameCtrl.text.trim(),
        documentType: _docType,
        documentNumber: _docCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Datos del cliente', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Nombre / Razón social'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _docType,
            decoration: const InputDecoration(labelText: 'Tipo documento'),
            items: const [
              DropdownMenuItem(value: 'CC', child: Text('CC')),
              DropdownMenuItem(value: 'NIT', child: Text('NIT')),
              DropdownMenuItem(value: 'CE', child: Text('CE')),
            ],
            onChanged: (v) => _docType = v ?? 'CC',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _docCtrl,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Número de documento'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressCtrl,
            decoration: const InputDecoration(labelText: 'Dirección'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _cityCtrl,
            decoration: const InputDecoration(labelText: 'Ciudad'),
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Guardar y continuar',
            icon: Icons.check_rounded,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
