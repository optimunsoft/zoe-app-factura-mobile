import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/customer.dart';
import '../../../modules/third-party/domain/models/third_party_models.dart';
import '../../../modules/third-party/store/thirdparty.store.dart';
import '../../atoms/app_button.dart';
import '../../atoms/boton_menu_drawer.dart';
import '../../molecules/barra_busqueda_escaner.dart';
import 'widgets/formulario_crear_cliente.dart';
import 'widgets/lista_clientes.dart';

/// Pantalla 1 del flujo POS: buscar, seleccionar o crear cliente.
class SeleccionClientePage extends StatefulWidget {
  const SeleccionClientePage({
    super.key,
    required this.onCustomerSelected,
  });

  final ValueChanged<Customer> onCustomerSelected;

  @override
  State<SeleccionClientePage> createState() => _SeleccionClientePageState();
}

class _SeleccionClientePageState extends State<SeleccionClientePage> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  bool _creating = false;
  bool _selecting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _search();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(value);
    });
  }

  Future<void> _search([String? raw]) async {
    final text = (raw ?? _searchCtrl.text).trim();
    await context.read<ThirdPartyStore>().searchByAny(text);
  }

  Customer _toCustomer(ThirdParty t) {
    return Customer(
      id: t.id.toString(),
      name: t.displayName.isEmpty ? 'Sin nombre' : t.displayName,
      documentType: t.documentType?.type ??
          (t.documentTypeId != null ? '${t.documentTypeId}' : ''),
      documentNumber: t.identificationNumber,
      email: t.email ?? '',
      phone: t.phone1 ?? '',
      address: t.address ?? '',
      city: t.city ?? '',
      taxId: t.verificationDigit,
      freeZone: t.freeZone,
      foreign: t.foreign,
    );
  }

  /// Listado → detalle por id → seleccionar en el flujo POS.
  Future<void> _selectFromList(Customer preview) async {
    final id = int.tryParse(preview.id);
    if (id == null) {
      widget.onCustomerSelected(preview);
      return;
    }

    setState(() => _selecting = true);

    final store = context.read<ThirdPartyStore>();
    await store.loadById(id);

    if (!mounted) return;
    setState(() => _selecting = false);

    if (store.error != null || store.selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(store.error ?? 'No se pudo cargar el cliente'),
        ),
      );
      return;
    }

    widget.onCustomerSelected(_toCustomer(store.selected!));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ThirdPartyStore>();
    final customers = store.items.map(_toCustomer).toList();

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
            : BotonMenuDrawer.leadingDe(context),
        leadingWidth: _creating ? null : BotonMenuDrawer.leadingWidthDe(context),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          _creating
              ? CustomerCreateForm(
                  onCreated: (thirdParty) {
                    widget.onCustomerSelected(_toCustomer(thirdParty));
                  },
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: BarraBusquedaEscaner(
                        controller: _searchCtrl,
                        hint: 'Buscar por razón social, NIT o contacto…',
                        onChanged: _onSearchChanged,
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
                    if (store.error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          store.error!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    Expanded(
                      child: store.isLoading && !_selecting
                          ? const Center(child: CircularProgressIndicator())
                          : ListaClientes(
                              customers: customers,
                              onSelect: _selectFromList,
                            ),
                    ),
                  ],
                ),
          if (_selecting)
            const ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [SeleccionClientePage].
typedef CustomerSelectionPage = SeleccionClientePage;
