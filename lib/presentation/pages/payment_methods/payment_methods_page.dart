import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/payment_method.dart';
import '../../../modules/method_payments/domain/models/method_payments.models.dart';
import '../../../modules/method_payments/store/method_payments.store.dart';
import '../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../modules/taxes/store/taxes.store.dart';
import 'widgets/payment_methods_panel.dart';
import 'widgets/payment_summary_footer.dart';
import 'widgets/retefuente_sheet.dart';

/// Pantalla 2 — Formas de pago (API medios de pago).
class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final Map<int, TextEditingController> _controllers = {};
  final Set<int> _lockedIds = {};
  final Map<int, double> _confirmedAmounts = {};

  int? _selectedReteIvaId;
  int? _selectedReteIcaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MethodPaymentsStore>().loadAll().then((_) {
        if (!mounted) return;
        _syncControllers(context.read<MethodPaymentsStore>().items);
      });
      context.read<TaxesStore>().loadAll(
            query: TaxesQuery(page: '1', amount: '100'),
          );
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<MethodPayment> items) {
    for (final item in items) {
      _controllers.putIfAbsent(item.id, TextEditingController.new);
    }
    setState(() {});
  }

  double get _paid =>
      _confirmedAmounts.values.fold(0.0, (sum, a) => sum + a);

  TaxRetention? _findById(List<TaxRetention> options, int? id) {
    if (id == null) return null;
    for (final item in options) {
      if (item.id == id) return item;
    }
    return null;
  }

  /// Base ReteIVA: monto de IVA del carrito.
  double _ivaBase(PosController pos) {
    return pos.taxBreakdown
        .where((t) => t.isIva)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Base ReteICA: subtotal (base imponible).
  double _icaBase(PosController pos) => pos.subtotal;

  double _reteIvaAmount(PosController pos, TaxRetention? selected) {
    return selected?.amountOn(_ivaBase(pos)) ?? 0;
  }

  double _reteIcaAmount(PosController pos, TaxRetention? selected) {
    return selected?.amountOn(_icaBase(pos)) ?? 0;
  }

  /// Total a cobrar restando retenciones opcionales.
  double _payableTotal(
    PosController pos, {
    required TaxRetention? reteIva,
    required TaxRetention? reteIca,
    required double reteFuente,
  }) {
    final net = pos.total -
        _reteIvaAmount(pos, reteIva) -
        _reteIcaAmount(pos, reteIca) -
        reteFuente;
    return net < 0 ? 0 : net;
  }

  double get _cashReceived {
    final store = context.read<MethodPaymentsStore>();
    var sum = 0.0;
    for (final entry in _confirmedAmounts.entries) {
      final method = store.items.cast<MethodPayment?>().firstWhere(
            (m) => m?.id == entry.key,
            orElse: () => null,
          );
      if (method?.isCash == true) sum += entry.value;
    }
    return sum;
  }

  PaymentMethod _toPosMethod() {
    final store = context.read<MethodPaymentsStore>();
    final confirmed = store.items
        .where((m) => _confirmedAmounts.containsKey(m.id))
        .toList();

    if (confirmed.length == 1) {
      final m = confirmed.first;
      if (m.isCash) return PaymentMethod.cash;
      if (m.isTransfer) return PaymentMethod.transfer;
    }
    return PaymentMethod.mixed;
  }

  void _onAdd(
    MethodPayment method, {
    required double payable,
  }) {
    final ctrl = _controllers[method.id];
    if (ctrl == null) return;

    final amount = CurrencyFormat.parseInput(ctrl.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido')),
      );
      return;
    }

    final othersPaid = _paid - (_confirmedAmounts[method.id] ?? 0);
    final remaining = payable - othersPaid;
    if (amount > remaining + 0.001) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El monto supera lo por pagar (${CurrencyFormat.money(remaining < 0 ? 0 : remaining)})',
          ),
        ),
      );
      return;
    }

    setState(() {
      _confirmedAmounts[method.id] = amount;
      _lockedIds.add(method.id);
    });
  }

  void _onEdit(MethodPayment method) {
    setState(() {
      _lockedIds.remove(method.id);
      _confirmedAmounts.remove(method.id);
    });
  }

  void _completeSale(PosController pos, double payable) {
    if (pos.itemCount == 0 || _confirmedAmounts.isEmpty) return;

    if (_paid < payable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El monto pagado es insuficiente')),
      );
      return;
    }

    final cash = _cashReceived;
    pos.completeSale(
      method: _toPosMethod(),
      cashReceived: cash > 0 ? cash : null,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final store = context.watch<MethodPaymentsStore>();
    final taxesStore = context.watch<TaxesStore>();

    final reteIvaOptions = taxesStore.reteIvaOptions;
    final reteIcaOptions = taxesStore.reteIcaOptions;
    final reteFuenteOptions = taxesStore.reteFuenteOptions;
    final selectedReteIva = _findById(reteIvaOptions, _selectedReteIvaId);
    final selectedReteIca = _findById(reteIcaOptions, _selectedReteIcaId);

    final reteIvaAmount = _reteIvaAmount(pos, selectedReteIva);
    final reteIcaAmount = _reteIcaAmount(pos, selectedReteIca);
    final reteFuenteAmount = pos.reteFuenteTotal(reteFuenteOptions);
    final payable = _payableTotal(
      pos,
      reteIva: selectedReteIva,
      reteIca: selectedReteIca,
      reteFuente: reteFuenteAmount,
    );

    if (store.items.isNotEmpty &&
        store.items.any((i) => !_controllers.containsKey(i.id))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncControllers(store.items);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Formas de pago', style: AppTextStyles.h2),
      ),
      body: _buildBody(store, pos, payable),
      bottomNavigationBar: PaymentSummaryFooter(
        subtotal: pos.subtotal,
        taxBreakdown: pos.taxBreakdown,
        total: pos.total,
        payableTotal: payable,
        reteIvaOptions: reteIvaOptions,
        reteIcaOptions: reteIcaOptions,
        selectedReteIva: selectedReteIva,
        selectedReteIca: selectedReteIca,
        reteIvaAmount: reteIvaAmount,
        reteIcaAmount: reteIcaAmount,
        reteFuenteAmount: reteFuenteAmount,
        onReteIvaChanged: (value) => setState(() {
          _selectedReteIvaId = value?.id;
        }),
        onReteIcaChanged: (value) => setState(() {
          _selectedReteIcaId = value?.id;
        }),
        onOpenReteFuente: () => ReteFuenteSheet.show(context),
        canComplete: pos.itemCount > 0 &&
            _confirmedAmounts.isNotEmpty &&
            _paid >= payable,
        onComplete: () => _completeSale(pos, payable),
      ),
    );
  }

  Widget _buildBody(
    MethodPaymentsStore store,
    PosController pos,
    double payable,
  ) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                store.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => store.loadAll(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (store.items.isEmpty) {
      return Center(
        child: Text(
          'No hay medios de pago configurados',
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    if (_controllers.length < store.items.length) {
      return const Center(child: CircularProgressIndicator());
    }

    return PaymentMethodsPanel(
      items: store.items,
      controllers: _controllers,
      lockedIds: _lockedIds,
      confirmedAmounts: _confirmedAmounts,
      total: payable,
      onAdd: (method) => _onAdd(method, payable: payable),
      onEdit: _onEdit,
    );
  }
}
