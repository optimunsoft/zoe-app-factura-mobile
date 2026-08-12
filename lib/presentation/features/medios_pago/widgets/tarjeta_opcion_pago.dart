import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../atoms/money_text.dart';

/// Fila compacta de medio de pago; el editor solo se muestra si [expanded].
class TarjetaOpcionPago extends StatelessWidget {
  const TarjetaOpcionPago({
    super.key,
    required this.label,
    required this.icon,
    required this.amountController,
    required this.locked,
    required this.expanded,
    required this.onSelect,
    required this.onAdd,
    required this.onEdit,
    this.confirmedAmount,
    this.remainingHint,
  });

  final String label;
  final IconData icon;
  final TextEditingController amountController;
  final bool locked;
  final bool expanded;
  final VoidCallback onSelect;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final double? confirmedAmount;
  final double? remainingHint;

  @override
  Widget build(BuildContext context) {
    final hasAmount = confirmedAmount != null && confirmedAmount! > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: expanded || locked ? AppColors.primary : AppColors.border,
          width: expanded || locked ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: locked || expanded
                          ? AppColors.primaryLight
                          : AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: locked || expanded
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.label.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasAmount) ...[
                    MoneyText(
                      confirmedAmount!,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: AppColors.success,
                    ),
                  ] else
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: AppColors.textMuted,
                    ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!locked &&
                      remainingHint != null &&
                      remainingHint! > 0.001) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          amountController.text =
                              CurrencyFormat.formatInput(remainingHint!);
                          amountController.selection =
                              TextSelection.collapsed(
                            offset: amountController.text.length,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Cubrir resto (${CurrencyFormat.money(remainingHint!)})',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          enabled: !locked,
                          autofocus: !locked,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: AppTextStyles.money.copyWith(
                            fontSize: 15,
                            color: locked
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                          inputFormatters: [CurrencyInputFormatter()],
                          decoration: InputDecoration(
                            hintText: 'Monto',
                            hintStyle: AppTextStyles.bodySmall,
                            prefixText: '\$ ',
                            isDense: true,
                            filled: true,
                            fillColor: locked
                                ? AppColors.surfaceAlt.withValues(alpha: 0.7)
                                : AppColors.surfaceAlt,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.border),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: locked ? onEdit : onAdd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: locked
                                ? AppColors.surface
                                : AppColors.primary,
                            foregroundColor: locked
                                ? AppColors.primary
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            elevation: locked ? 0 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: locked
                                  ? const BorderSide(color: AppColors.primary)
                                  : BorderSide.none,
                            ),
                          ),
                          child: Text(
                            locked ? 'Modificar' : 'Añadir',
                            style: AppTextStyles.button.copyWith(
                              color: locked
                                  ? AppColors.primary
                                  : Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Alias legacy — usar [TarjetaOpcionPago].
typedef PaymentOptionTile = TarjetaOpcionPago;
