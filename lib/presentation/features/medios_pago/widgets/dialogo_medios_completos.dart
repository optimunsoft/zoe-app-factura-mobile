import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_format.dart';

/// Avisa que todos los medios ya tienen monto y aún falta por cubrir.
Future<void> mostrarAlertaMediosCompletos(
  BuildContext context, {
  required double faltante,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Medios de pago completos', style: AppTextStyles.h3),
      content: Text(
        'Ya se asignó un monto a todos los medios de pago y todavía falta '
        '${CurrencyFormat.money(faltante)} por registrar. '
        'Modifica alguno para cubrir el valor restante.',
        style: AppTextStyles.body,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(
            'Entendido',
            style: AppTextStyles.label.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    ),
  );
}
