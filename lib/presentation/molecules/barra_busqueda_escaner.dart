import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class BarraBusquedaEscaner extends StatelessWidget {
  const BarraBusquedaEscaner({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onScan,
    this.hint = 'Buscar producto o código…',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onScan;
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
        suffixIcon: IconButton(
          tooltip: 'Escanear código',
          onPressed: onScan ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Escáner listo (simulado)')),
                );
              },
          icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.primary),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [BarraBusquedaEscaner].
typedef SearchBarWithScan = BarraBusquedaEscaner;
