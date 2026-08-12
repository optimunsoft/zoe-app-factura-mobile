import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Diálogo opcional de observaciones al emitir la venta.
///
/// Retorna el texto (puede ser `""`) o `null` si cancela.
Future<String?> showSaleNotesDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _SaleNotesDialog(),
  );
}

class _SaleNotesDialog extends StatefulWidget {
  const _SaleNotesDialog();

  @override
  State<_SaleNotesDialog> createState() => _SaleNotesDialogState();
}

class _SaleNotesDialogState extends State<_SaleNotesDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Observaciones', style: AppTextStyles.h3),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        minLines: 3,
        autofocus: true,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: 'Opcional',
          hintStyle: AppTextStyles.bodySmall,
          filled: true,
          fillColor: AppColors.surfaceAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(
            'Continuar',
            style: AppTextStyles.label.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
