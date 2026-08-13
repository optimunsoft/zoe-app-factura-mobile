import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Buscador de texto (productos / terceros).
class BarraBusquedaEscaner extends StatelessWidget {
  const BarraBusquedaEscaner({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Buscar producto o código…',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
      ),
    );
  }
}

/// Alias legacy — usar [BarraBusquedaEscaner].
typedef SearchBarWithScan = BarraBusquedaEscaner;
