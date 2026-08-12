import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';

class CampoMontoEfectivo extends StatelessWidget {
  const CampoMontoEfectivo({
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
          inputFormatters: [CurrencyInputFormatter()],
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

/// Alias legacy — usar [CampoMontoEfectivo].
typedef CashAmountField = CampoMontoEfectivo;
