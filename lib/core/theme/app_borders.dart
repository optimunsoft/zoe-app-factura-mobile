import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Grosores y bordes centralizados del design system.
///
/// Solo existen dos grosores: [thin] en reposo y [strong] en estado activo.
abstract final class AppBorders {
  static const double thin = 1;
  static const double strong = 1.5;

  static Border get subtle =>
      Border.all(color: AppColors.border, width: thin);

  /// Lado que reacciona al estado de selección de un control.
  static BorderSide selectableSide({required bool selected}) => BorderSide(
        color: selected ? AppColors.primary : AppColors.border,
        width: selected ? strong : thin,
      );

  /// Borde que reacciona al estado de selección de un control.
  static Border selectable({required bool selected}) =>
      Border.fromBorderSide(selectableSide(selected: selected));

  static BorderSide get side =>
      BorderSide(color: AppColors.border, width: thin);

  /// Línea superior de las barras acopladas al borde inferior.
  static Border get top => Border(
        top: BorderSide(color: AppColors.border, width: thin),
      );
}
