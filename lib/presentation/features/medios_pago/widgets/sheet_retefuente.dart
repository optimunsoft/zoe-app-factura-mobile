import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/pos_controller.dart';
import '../../../../domain/models/cart_item.dart';
import '../../../../modules/taxes/domain/checkout_tax_calculator.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../../modules/taxes/store/taxes.store.dart';
import '../../../atoms/app_button.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/pct_retention_dropdown.dart';
import '../../../molecules/cuerpo_error_reintentar.dart';
import '../../../organisms/sheet_inferior_app.dart';

/// Ventana: Retención ReteFuente (por producto).
class SheetReteFuente extends StatefulWidget {
  const SheetReteFuente({super.key});

  static Future<void> show(BuildContext context) {
    final taxesStore = context.read<TaxesStore>();
    if (taxesStore.items.isEmpty && !taxesStore.isLoading) {
      taxesStore.loadAll(query: TaxesQuery(page: '1', amount: '100'));
    }

    return SheetInferiorApp.show<void>(
      context,
      child: const SheetReteFuente(),
    );
  }

  @override
  State<SheetReteFuente> createState() => _SheetReteFuenteState();
}

class _SheetReteFuenteState extends State<SheetReteFuente> {
  /// productId → retención id (null = sin retefuente).
  late Map<String, int?> _draft;
  var _draftReady = false;

  void _ensureDraft(PosController pos) {
    if (_draftReady) return;
    _draft = {
      for (final item in pos.cart) item.product.id: item.reteFuenteId,
    };
    _draftReady = true;
  }

  double _draftAmountFor(
    CartItem item,
    List<TaxRetention> options,
    PosController pos,
  ) {
    final selected =
        CheckoutTaxCalculator.findById(options, _draft[item.product.id]);
    if (selected == null) return 0;
    return selected.amountOn(
      item.withholdingBase(ivaIncluido: pos.ivaIncluido),
    );
  }

  double _draftTotal(PosController pos, List<TaxRetention> options) {
    return pos.cart.fold<double>(
      0,
      (sum, item) => sum + _draftAmountFor(item, options, pos),
    );
  }

  void _addAndClose(PosController pos) {
    for (final entry in _draft.entries) {
      pos.setReteFuente(entry.key, entry.value);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final taxesStore = context.watch<TaxesStore>();
    _ensureDraft(pos);

    final options = taxesStore.reteFuenteOptions;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final totalRete = _draftTotal(pos, options);
    final canAdd = options.isNotEmpty && pos.cart.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Text('ReteFuente', style: AppTextStyles.h2),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Elige el porcentaje por producto y pulsa Añadir.',
            style: AppTextStyles.bodySmall,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildBody(pos, taxesStore, options),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottom),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total ReteFuente',
                      style: AppTextStyles.h3,
                    ),
                  ),
                  MoneyText(
                    totalRete > 0 ? -totalRete : 0,
                    large: true,
                    color: totalRete > 0
                        ? AppColors.danger
                        : AppColors.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Añadir',
                icon: Icons.add_rounded,
                onPressed: canAdd ? () => _addAndClose(pos) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    PosController pos,
    TaxesStore taxesStore,
    List<TaxRetention> options,
  ) {
    if (taxesStore.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (taxesStore.error != null) {
      return CuerpoErrorReintentar(
        message: taxesStore.error!,
        onRetry: () => taxesStore.loadAll(
          query: TaxesQuery(page: '1', amount: '100'),
        ),
      );
    }

    if (pos.cart.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No hay productos en el carrito',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    if (options.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No hay retefuentes (código 06) configuradas',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: pos.cart.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = pos.cart[index];
        final selected = CheckoutTaxCalculator.findById(
          options,
          _draft[item.product.id],
        );
        return TarjetaLineaReteFuente(
          item: item,
          options: options,
          selected: selected,
          amount: _draftAmountFor(item, options, pos),
          onChanged: (value) {
            setState(() {
              _draft[item.product.id] = value?.id;
            });
          },
        );
      },
    );
  }
}

/// Tarjeta de una línea de producto con selector ReteFuente.
class TarjetaLineaReteFuente extends StatelessWidget {
  const TarjetaLineaReteFuente({
    super.key,
    required this.item,
    required this.options,
    required this.selected,
    required this.amount,
    required this.onChanged,
  });

  final CartItem item;
  final List<TaxRetention> options;
  final TaxRetention? selected;
  final double amount;
  final ValueChanged<TaxRetention?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.product.name,
            style: AppTextStyles.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Cant. ${item.quantity}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'ReteFuente',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              PctRetentionDropdown(
                selected: selected,
                options: options,
                onChanged: onChanged,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 104,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: MoneyText(
                    amount > 0 ? -amount : 0,
                    color:
                        amount > 0 ? AppColors.danger : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [SheetReteFuente].
typedef ReteFuenteSheet = SheetReteFuente;
