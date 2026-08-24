import 'package:flutter/material.dart';

import '../../core/layout/ancho_vista.dart';
import '../../core/theme/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Shell reutilizable para slide-overs / bottom sheets / diálogo en escritorio.
class SheetInferiorApp extends StatelessWidget {
  const SheetInferiorApp({
    super.key,
    required this.child,
    this.maxHeightFactor = 0.88,
    this.padding = EdgeInsets.zero,
    this.comoDialogo = false,
  });

  final Widget child;
  final double maxHeightFactor;
  final EdgeInsets padding;
  final bool comoDialogo;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    double maxHeightFactor = 0.88,
  }) {
    final comoDialogo = AnchoVista.usaDialogoSheet(context);
    if (comoDialogo) {
      return showDialog<T>(
        context: context,
        builder: (_) => SheetInferiorApp(
          maxHeightFactor: maxHeightFactor,
          comoDialogo: true,
          child: child,
        ),
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SheetInferiorApp(
        maxHeightFactor: maxHeightFactor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = comoDialogo ? 0.0 : MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;
    final cuerpo = _CuerpoSheet(
      mostrarHandle: !comoDialogo,
      bottom: bottom,
      child: child,
    );

    if (comoDialogo) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppBreakpoints.anchoSheet,
            maxHeight: maxHeight,
          ),
          child: Material(
            color: AppColors.surface,
            borderRadius: AppRadius.lgAll,
            clipBehavior: Clip.antiAlias,
            child: cuerpo,
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.sheetTop,
        ),
        child: cuerpo,
      ),
    );
  }
}

class _CuerpoSheet extends StatelessWidget {
  const _CuerpoSheet({
    required this.mostrarHandle,
    required this.bottom,
    required this.child,
  });

  final bool mostrarHandle;
  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (mostrarHandle) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
              0,
            ),
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  tooltip: 'Cerrar',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [SheetInferiorApp].
typedef AppBottomSheet = SheetInferiorApp;
