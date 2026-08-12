import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';

/// Footer de listado con botón "Cargar más".
class PieCargarMas extends StatelessWidget {
  const PieCargarMas({
    super.key,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    this.label = 'Cargar más',
  });

  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (!hasMore) return const SizedBox.shrink();

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AppButton(
        label: label,
        icon: Icons.expand_more_rounded,
        onPressed: onLoadMore,
      ),
    );
  }
}

/// Alias legacy — usar [PieCargarMas].
typedef LoadMoreFooter = PieCargarMas;
