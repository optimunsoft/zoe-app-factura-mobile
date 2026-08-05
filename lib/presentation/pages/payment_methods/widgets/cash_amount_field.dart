import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class CashAmountField extends StatelessWidget {
  const CashAmountField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Monto recibido', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTextStyles.moneyLg,
          onChanged: onChanged,
          decoration: const InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
          ),
        ),
      ],
    );
  }
}
