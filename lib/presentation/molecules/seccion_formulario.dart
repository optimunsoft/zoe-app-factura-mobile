import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Título de sección de formulario con divisor.
class SeccionFormulario extends StatelessWidget {
  const SeccionFormulario({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 20, color: AppColors.border),
          ..._withGaps(children, AppSpacing.lg),
        ],
      ),
    );
  }

  List<Widget> _withGaps(List<Widget> items, double gap) {
    if (items.isEmpty) return const [];
    final out = <Widget>[items.first];
    for (var i = 1; i < items.length; i++) {
      out.add(SizedBox(height: gap));
      out.add(items[i]);
    }
    return out;
  }
}

/// Switch con estilo de tarjeta para flags booleanos.
class InterruptorBandera extends StatelessWidget {
  const InterruptorBandera({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      tileColor: AppColors.surfaceAlt,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      title: Text(label, style: AppTextStyles.label),
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Alias legacy — usar [SeccionFormulario].
typedef FormSection = SeccionFormulario;

/// Alias legacy — usar [InterruptorBandera].
typedef FlagTile = InterruptorBandera;
