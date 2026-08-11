import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';

/// Método de pago: título arriba; monto + Añadir/Modificar debajo.
class PaymentOptionTile extends StatelessWidget {
  const PaymentOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.amountController,
    required this.locked,
    required this.onAdd,
    required this.onEdit,
  });

  final String label;
  final IconData icon;
  final TextEditingController amountController;
  final bool locked;
  final VoidCallback onAdd;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: locked ? AppColors.primary : AppColors.border,
          width: locked ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: locked ? AppColors.primaryLight : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: locked ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amountController,
                  enabled: !locked,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.money.copyWith(
                    fontSize: 15,
                    color: locked
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                  inputFormatters: [CurrencyInputFormatter()],
                  decoration: InputDecoration(
                    hintText: 'Ingrese el monto',
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
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary),
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
                    backgroundColor:
                        locked ? AppColors.surface : AppColors.primary,
                    foregroundColor:
                        locked ? AppColors.primary : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      color: locked ? AppColors.primary : Colors.white,
                      fontSize: 13,
                    ),
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
