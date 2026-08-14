import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Visor de un PDF en memoria (bytes) con [pdfrx].
class VisorPdfDocumento extends StatelessWidget {
  const VisorPdfDocumento({
    super.key,
    required this.bytes,
    this.sourceName = 'documento_venta.pdf',
  });

  final Uint8List bytes;

  /// Identificador estable del origen (requerido por pdfrx).
  final String sourceName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppRadius.mdAll,
        border: AppBorders.subtle,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.mdAll,
        child: PdfViewer.data(
          bytes,
          sourceName: sourceName,
          params: PdfViewerParams(
            backgroundColor: AppColors.surfaceAlt,
            errorBannerBuilder: (context, error, stackTrace, documentRef) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'Error al mostrar el PDF: $error',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
