import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../../modules/taxes/domain/checkout_tax_calculator.dart';
import '../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../modules/taxes/store/taxes.store.dart';
import '../../atoms/app_button.dart';
import '../../molecules/cuerpo_error_reintentar.dart';
import '../medios_pago/medios_pago_page.dart';
import '../medios_pago/widgets/sheet_retefuente.dart';
import 'widgets/tarjeta_resumen_venta.dart';

/// Ventana: Resumen de venta (retenciones → medios de pago).
class ResumenVentaPage extends StatefulWidget {
  const ResumenVentaPage({super.key});

  @override
  State<ResumenVentaPage> createState() => _ResumenVentaPageState();
}

class _ResumenVentaPageState extends State<ResumenVentaPage> {
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

  Future<void> _continueToPayments() async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MediosPagoPage(
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
    final selectedReteIva =
        CheckoutTaxCalculator.findById(reteIvaOptions, _selectedReteIvaId);
    final selectedReteIca =
        CheckoutTaxCalculator.findById(reteIcaOptions, _selectedReteIcaId);
    final reteFuenteAmount =
        pos.reteFuenteTotal(taxesStore.reteFuenteOptions);
    final amountDue = CheckoutTaxCalculator.amountDue(
      pos,
      reteIva: selectedReteIva,
      reteIca: selectedReteIca,
      reteFuente: reteFuenteAmount,
      round: false,
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
        reteIvaAmount:
            CheckoutTaxCalculator.reteIvaAmount(pos, selectedReteIva),
        reteIcaAmount:
            CheckoutTaxCalculator.reteIcaAmount(pos, selectedReteIca),
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
      return CuerpoErrorReintentar(
        message: taxesStore.error!,
        onRetry: () => taxesStore.loadAll(
          query: TaxesQuery(page: '1', amount: '100'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SizedBox.expand(
        child:         TarjetaResumenVenta(
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
          onOpenReteFuente: () => SheetReteFuente.show(context),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [ResumenVentaPage].
typedef CheckoutSummaryPage = ResumenVentaPage;
