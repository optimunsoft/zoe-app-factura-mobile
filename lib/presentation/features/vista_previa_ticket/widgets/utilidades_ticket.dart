import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../atoms/money_text.dart';

/// Línea divisoria punteada del ticket térmico.
class TicketDivisor extends StatelessWidget {
  const TicketDivisor({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        final count = (constraints.maxWidth / (dashWidth * 1.6)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              color: AppColors.receiptLine.withValues(alpha: 0.55),
            ),
          ),
        );
      },
    );
  }
}

/// Fila de texto clave-valor del ticket térmico.
class TicketLinea extends StatelessWidget {
  const TicketLinea({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.receipt)),
          Text(
            value,
            style: AppTextStyles.receipt.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Fila de monto del ticket térmico.
class TicketLineaMonto extends StatelessWidget {
  const TicketLineaMonto({
    super.key,
    required this.label,
    required this.amount,
    this.bold = false,
  });

  final String label;
  final num amount;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.receipt.copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                fontSize: bold ? 13 : 11,
              ),
            ),
          ),
          MoneyText(
            amount,
            style: AppTextStyles.receipt.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: bold ? 13 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
