import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/pos_controller.dart';
import '../../modules/sales/store/sales.store.dart';

/// Confirma y cierra la sesión. Única implementación del flujo de logout UI.
Future<void> confirmarCerrarSesion(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Seguro que quieres salir de la aplicación?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            'Salir',
            style: AppTextStyles.label.copyWith(color: AppColors.danger),
          ),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  context.read<SalesStore>().clearResumen();
  context.read<PosController>().startNewSale();
  await context.read<AuthController>().logout();
}
