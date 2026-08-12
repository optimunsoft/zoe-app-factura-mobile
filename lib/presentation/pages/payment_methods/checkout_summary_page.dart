import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../modules/taxes/store/taxes.store.dart';
import '../../atoms/app_button.dart';
import 'payment_methods_page.dart';
import 'widgets/checkout_summary_card.dart';
import 'widgets/retefuente_sheet.dart';

/// Pantalla intermedia: resumen + retenciones → formas de pago.
class CheckoutSummaryPage extends StatefulWidget {
  const CheckoutSummaryPage({super.key});

  @override
  State<CheckoutSummaryPage> createState() => _CheckoutSummaryPageState();
}

class _CheckoutSummaryPageState extends State<CheckoutSummaryPage> {
  int? _selectedReteIvaId;
  int? _selectedReteIcaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaxesStore>().loadAll(
            query: TaxesQuery(page: '1', amount: '100'),
          );
    });
  }

  TaxRetention? _findById(List<TaxRetention> options, int? id) {
    if (id == null) return null;
    for (final item in options) {
      if (item.id == id) return item;
    }
    return null;
  }

  double _ivaBase(PosController pos) {
    return pos.taxBreakdown
        .where((t) => t.isIva)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _reteIvaAmount(PosController pos, TaxRetention? selected) {
    return selected?.amountOn(_ivaBase(pos)) ?? 0;
  }

  double _reteIcaAmount(PosController pos, TaxRetention? selected) {
    return selected?.amountOn(pos.subtotal) ?? 0;
  }

  double _amountDue(
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

  Future<void> _continueToPayments() async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaymentMethodsPage(
          selectedReteIvaId: _selectedReteIvaId,
          selectedReteIcaId: _selectedReteIcaId,
        ),
      ),
    );
    if (completed == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final taxesStore = context.watch<TaxesStore>();

    final reteIvaOptions = taxesStore.reteIvaOptions;
    final reteIcaOptions = taxesStore.reteIcaOptions;
    final selectedReteIva = _findById(reteIvaOptions, _selectedReteIvaId);
    final selectedReteIca = _findById(reteIcaOptions, _selectedReteIcaId);
    final reteFuenteAmount =
        pos.reteFuenteTotal(taxesStore.reteFuenteOptions);
    final amountDue = _amountDue(
      pos,
      reteIva: selectedReteIva,
      reteIca: selectedReteIca,
      reteFuente: reteFuenteAmount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de la compra', style: AppTextStyles.h2),
      ),
      body: _buildBody(
        taxesStore: taxesStore,
        pos: pos,
        amountDue: amountDue,
        reteIvaOptions: reteIvaOptions,
        reteIcaOptions: reteIcaOptions,
        selectedReteIva: selectedReteIva,
        selectedReteIca: selectedReteIca,
        reteIvaAmount: _reteIvaAmount(pos, selectedReteIva),
        reteIcaAmount: _reteIcaAmount(pos, selectedReteIca),
        reteFuenteAmount: reteFuenteAmount,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(top: BorderSide(color: AppColors.border)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: AppButton(
            label: 'Continuar a formas de pago',
            icon: Icons.arrow_forward_rounded,
            onPressed: pos.itemCount > 0 ? _continueToPayments : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required TaxesStore taxesStore,
    required PosController pos,
    required double amountDue,
    required List<TaxRetention> reteIvaOptions,
    required List<TaxRetention> reteIcaOptions,
    required TaxRetention? selectedReteIva,
    required TaxRetention? selectedReteIca,
    required double reteIvaAmount,
    required double reteIcaAmount,
    required double reteFuenteAmount,
  }) {
    if (taxesStore.isLoading && taxesStore.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taxesStore.error != null && taxesStore.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                taxesStore.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => taxesStore.loadAll(
                  query: TaxesQuery(page: '1', amount: '100'),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SizedBox.expand(
        child:         CheckoutSummaryCard(
          subtotal: pos.subtotal,
          taxBreakdown: pos.taxBreakdown,
          total: pos.total,
          payableTotal: amountDue,
          reteIvaOptions: reteIvaOptions,
          reteIcaOptions: reteIcaOptions,
          selectedReteIva: selectedReteIva,
          selectedReteIca: selectedReteIca,
          reteIvaAmount: reteIvaAmount,
          reteIcaAmount: reteIcaAmount,
          reteFuenteAmount: reteFuenteAmount,
          fillHeight: true,
          onReteIvaChanged: (value) => setState(() {
            _selectedReteIvaId = value?.id;
          }),
          onReteIcaChanged: (value) => setState(() {
            _selectedReteIcaId = value?.id;
          }),
          onOpenReteFuente: () => ReteFuenteSheet.show(context),
        ),
      ),
    );
  }
}
