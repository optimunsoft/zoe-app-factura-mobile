import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/pos_controller.dart';
import '../../../../domain/models/cart_item.dart';
import '../../../../modules/taxes/domain/models/taxes.models.dart';
import '../../../../modules/taxes/store/taxes.store.dart';
import '../../../atoms/app_button.dart';
import '../../../atoms/money_text.dart';
import '../../../atoms/pct_retention_dropdown.dart';

/// Slide-over para aplicar retefuente (código 06) por producto del carrito.
class ReteFuenteSheet extends StatelessWidget {
  const ReteFuenteSheet({super.key});

  static Future<void> show(BuildContext context) {
    final taxesStore = context.read<TaxesStore>();
    if (taxesStore.items.isEmpty && !taxesStore.isLoading) {
      taxesStore.loadAll(query: TaxesQuery(page: '1', amount: '100'));
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReteFuenteSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final taxesStore = context.watch<TaxesStore>();
    final options = taxesStore.reteFuenteOptions;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;
    final totalRete = pos.reteFuenteTotal(options);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: maxHeight,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text('ReteFuente', style: AppTextStyles.h2),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Elige el porcentaje por producto. Código 06.',
                style: AppTextStyles.bodySmall,
              ),
            ),
            if (options.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppButton(
                  label: 'Quitar todas',
                  variant: AppButtonVariant.secondary,
                  height: 42,
                  onPressed: pos.cart.any((e) => e.reteFuenteId != null)
                      ? () => pos.clearAllReteFuente()
                      : null,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: _buildBody(context, pos, taxesStore, options),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottom),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
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
      return Padding(
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
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = pos.cart[index];
        return _ReteFuenteLineCard(
          item: item,
          options: options,
          amount: pos.reteFuenteAmountFor(item, options),
          onChanged: (value) => pos.setReteFuente(
            item.product.id,
            value?.id,
          ),
        );
      },
    );
  }
}

class _ReteFuenteLineCard extends StatelessWidget {
  const _ReteFuenteLineCard({
    required this.item,
    required this.options,
    required this.amount,
    required this.onChanged,
  });

  final CartItem item;
  final List<TaxRetention> options;
  final double amount;
  final ValueChanged<TaxRetention?> onChanged;

  TaxRetention? get _selected {
    final id = item.reteFuenteId;
    if (id == null) return null;
    for (final option in options) {
      if (option.id == id) return option;
    }
    return null;
  }

  String _formatPct(double value) {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    final pctLabel = selected == null
        ? 'ReteFuente (0%)'
        : 'ReteFuente (${_formatPct(selected.percentageValue)}%)';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
            children: [
              Expanded(
                child: Text(
                  pctLabel,
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
              MoneyText(
                amount > 0 ? -amount : 0,
                color: amount > 0 ? AppColors.danger : AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
