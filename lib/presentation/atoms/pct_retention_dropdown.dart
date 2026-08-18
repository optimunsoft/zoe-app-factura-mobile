import 'package:flutter/material.dart';

import '../../core/theme/app_borders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../modules/taxes/domain/models/taxes.models.dart';

/// Etiqueta del estado sin retención aplicada.
const String kSinRetencionLabel = 'No aplica';

/// Select compacto de porcentaje de retención (cerrado: `15%` o `No aplica`).
class PctRetentionDropdown extends StatelessWidget {
  const PctRetentionDropdown({
    super.key,
    required this.selected,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.width = 104,
  });

  final TaxRetention? selected;
  final List<TaxRetention> options;
  final ValueChanged<TaxRetention?>? onChanged;
  final bool enabled;
  final double width;

  String _formatPct(double value) {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _menuLabel(TaxRetention item) {
    return '${_formatPct(item.percentageValue)}%';
  }

  TextStyle get _valueStyle => AppTextStyles.h3.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      );

  /// Estado sin retención: se lee como marcador de posición, no como valor.
  TextStyle get _noneStyle => AppTextStyles.label.copyWith(
        color: AppColors.textMuted,
        fontSize: 13,
      );

  @override
  Widget build(BuildContext context) {
    final canOpen = enabled && onChanged != null && options.isNotEmpty;

    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        borderRadius: AppRadius.smAll,
        onTap: canOpen
            ? () async {
                final box = context.findRenderObject() as RenderBox?;
                final overlay = Overlay.of(context).context.findRenderObject()
                    as RenderBox?;
                if (box == null || overlay == null) return;

                final position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    box.localToGlobal(Offset.zero, ancestor: overlay),
                    box.localToGlobal(
                      box.size.bottomRight(Offset.zero),
                      ancestor: overlay,
                    ),
                  ),
                  Offset.zero & overlay.size,
                );

                final result = await showMenu<Object>(
                  context: context,
                  position: position,
                  items: [
                    PopupMenuItem<Object>(
                      value: _noneSentinel,
                      child: Text(kSinRetencionLabel, style: _noneStyle),
                    ),
                    ...options.map(
                      (item) => PopupMenuItem<Object>(
                        value: item,
                        child: Text(_menuLabel(item), style: _valueStyle),
                      ),
                    ),
                  ],
                );

                if (result == null || onChanged == null) return;
                if (identical(result, _noneSentinel)) {
                  onChanged!(null);
                } else {
                  onChanged!(result as TaxRetention);
                }
              }
            : null,
        child: Container(
          width: width,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadius.smAll,
            border: AppBorders.subtle,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selected == null
                      ? kSinRetencionLabel
                      : '${_formatPct(selected!.percentageValue)}%',
                  style: selected == null ? _noneStyle : _valueStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const Object _noneSentinel = Object();
