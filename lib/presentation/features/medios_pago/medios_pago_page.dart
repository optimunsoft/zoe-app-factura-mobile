import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/api_helpers.dart';
import '../../../core/app_toast.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/currency_format.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/payment_method.dart';
import '../../../modules/method_payments/domain/models/method_payments.models.dart';
import '../../../modules/method_payments/store/method_payments.store.dart';
import '../../../modules/sales/domain/sale_request_builder.models.dart';
import '../../../modules/sales/store/sales.store.dart';
import '../../../modules/taxes/domain/checkout_tax_calculator.dart';
import '../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../modules/taxes/store/taxes.store.dart';
import '../../molecules/banner_monto_pendiente.dart';
import '../../molecules/cuerpo_error_reintentar.dart';
import 'widgets/panel_medios_pago.dart';
import 'widgets/pie_resumen_pago.dart';
import 'widgets/dialogo_notas_venta.dart';

/// Ventana: Medios de pago (retenciones ya definidas en el resumen).
class MediosPagoPage extends StatefulWidget {
  const MediosPagoPage({
    super.key,
    this.selectedReteIvaId,
    this.selectedReteIcaId,
  });

  final int? selectedReteIvaId;
  final int? selectedReteIcaId;

  @override
  State<MediosPagoPage> createState() => _MediosPagoPageState();
}

class _MediosPagoPageState extends State<MediosPagoPage> {
  final Map<int, TextEditingController> _controllers = {};
  final Set<int> _lockedIds = {};
  final Map<int, double> _confirmedAmounts = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MethodPaymentsStore>().loadAll().then((_) {
        if (!mounted) return;
        _syncControllers(context.read<MethodPaymentsStore>().items);
      });
      final taxes = context.read<TaxesStore>();
      if (taxes.items.isEmpty) {
        taxes.loadAll(query: TaxesQuery(page: '1', amount: '100'));
      }
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

  double get _paid => CurrencyFormat.roundMoney(
        _confirmedAmounts.values.fold(0.0, (sum, a) => sum + a),
      );

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

  List<int> get _generalWithholdingIds {
    return <int>[
      ?widget.selectedReteIvaId,
      ?widget.selectedReteIcaId,
    ];
  }

  bool _onAdd(
    MethodPayment method, {
    required double amountDue,
  }) {
    final ctrl = _controllers[method.id];
    if (ctrl == null) return false;

    final amount = CurrencyFormat.parseInput(ctrl.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido')),
      );
      return false;
    }

    final othersPaid = _paid - (_confirmedAmounts[method.id] ?? 0);
    final remaining = CurrencyFormat.roundMoney(amountDue - othersPaid);
    final amountCents = CurrencyFormat.toCents(amount);
    final remainingCents = CurrencyFormat.toCents(remaining < 0 ? 0 : remaining);
    if (amountCents > remainingCents) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El monto supera lo por pagar (${CurrencyFormat.money(remaining < 0 ? 0 : remaining)})',
          ),
        ),
      );
      return false;
    }

    setState(() {
      _confirmedAmounts[method.id] = CurrencyFormat.roundMoney(amount);
      _lockedIds.add(method.id);
    });
    return true;
  }

  void _onEdit(MethodPayment method) {
    setState(() {
      _lockedIds.remove(method.id);
      _confirmedAmounts.remove(method.id);
    });
  }

  Future<void> _completeSale(
    PosController pos, {
    required double amountDue,
  }) async {
    if (_isSubmitting) return;
    if (pos.itemCount == 0 || _confirmedAmounts.isEmpty) return;

    if (CurrencyFormat.toCents(_paid) < CurrencyFormat.toCents(amountDue)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El monto pagado es insuficiente')),
      );
      return;
    }

    final customer = pos.activeCustomer;
    if (customer == null || int.tryParse(customer.id) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un cliente válido')),
      );
      return;
    }

    final branchId = context.read<AuthController>().user?.sucursalId;
    if (branchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró la sucursal de la sesión')),
      );
      return;
    }

    final notes = await mostrarDialogoNotasVenta(context);
    if (!mounted || notes == null) return;

    setState(() => _isSubmitting = true);

    final navigator = Navigator.of(context);
    final salesStore = context.read<SalesStore>();
    var leftPage = false;

    try {
      // total_factura del endpoint = pos.total (sin restar retenciones).
      final request = SaleRequestBuilder.build(
        pos: pos,
        customer: customer,
        branchId: branchId,
        notes: notes,
        generalWithholdingIds: _generalWithholdingIds,
        confirmedPayments: Map<int, double>.from(_confirmedAmounts),
      );

      final result = await salesStore.createSale(request);
      if (!mounted) return;

      if (result == null) {
        // El toast con el mensaje del endpoint lo muestra [SalesStore].
        return;
      }

      final cash = _cashReceived;
      final orderId = result.documentNumber.isNotEmpty
          ? result.documentNumber
          : (result.id > 0 ? '${result.id}' : null);
      final totalOverride = result.totals?.total ?? pos.total;

      pos.completeSale(
        method: _toPosMethod(),
        cashReceived: cash > 0 ? cash : null,
        orderId: orderId,
        totalOverride: totalOverride,
      );

      if (!mounted) return;
      leftPage = true;
      navigator.pop(true);
    } catch (e) {
      if (!mounted) return;
      final message = cleanErrorMessage(e);
      AppToast.error(
        message.isNotEmpty ? message : 'No se pudo emitir el documento',
      );
    } finally {
      if (!leftPage && mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final store = context.watch<MethodPaymentsStore>();
    final taxesStore = context.watch<TaxesStore>();

    final selectedReteIva = CheckoutTaxCalculator.findById(
      taxesStore.reteIvaOptions,
      widget.selectedReteIvaId,
    );
    final selectedReteIca = CheckoutTaxCalculator.findById(
      taxesStore.reteIcaOptions,
      widget.selectedReteIcaId,
    );
    final reteFuenteAmount =
        pos.reteFuenteTotal(taxesStore.reteFuenteOptions);
    final amountDue = CheckoutTaxCalculator.amountDue(
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
      body: _buildBody(
        store: store,
        pos: pos,
        amountDue: amountDue,
      ),
      bottomNavigationBar: PieResumenPago(
        isSubmitting: _isSubmitting,
        canComplete: pos.itemCount > 0 &&
            _confirmedAmounts.isNotEmpty &&
            CurrencyFormat.toCents(_paid) >= CurrencyFormat.toCents(amountDue),
        onComplete: () => _completeSale(pos, amountDue: amountDue),
      ),
    );
  }

  Widget _buildBody({
    required MethodPaymentsStore store,
    required PosController pos,
    required double amountDue,
  }) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.error != null) {
      return CuerpoErrorReintentar(
        message: store.error!,
        onRetry: () => store.loadAll(),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: BannerMontoPendiente(
            label: 'Total a pagar',
            amount: amountDue,
            emphasized: true,
          ),
        ),
        Expanded(
          child: PanelMediosPago(
            items: store.items,
            controllers: _controllers,
            lockedIds: _lockedIds,
            confirmedAmounts: _confirmedAmounts,
            total: amountDue,
            onAdd: (method) => _onAdd(method, amountDue: amountDue),
            onEdit: _onEdit,
          ),
        ),
      ],
    );
  }
}

/// Alias legacy — usar [MediosPagoPage].
typedef PaymentMethodsPage = MediosPagoPage;
