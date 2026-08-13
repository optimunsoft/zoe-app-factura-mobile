import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/filtro_periodo_resumen.dart';
import '../../../atoms/app_button.dart';
import '../../../molecules/fila_rango_fechas.dart';
import '../../../organisms/sheet_inferior_app.dart';

/// Bottom sheet: filtro de periodo para Total ventas (inicio).
class SheetFiltroPeriodoResumen extends StatefulWidget {
  const SheetFiltroPeriodoResumen({
    super.key,
    required this.initial,
  });

  final FiltroPeriodoResumen initial;

  static Future<FiltroPeriodoResumen?> show(
    BuildContext context, {
    required FiltroPeriodoResumen initial,
  }) {
    return SheetInferiorApp.show<FiltroPeriodoResumen>(
      context,
      maxHeightFactor: 0.7,
      child: SheetFiltroPeriodoResumen(initial: initial),
    );
  }

  @override
  State<SheetFiltroPeriodoResumen> createState() =>
      _SheetFiltroPeriodoResumenState();
}

class _SheetFiltroPeriodoResumenState extends State<SheetFiltroPeriodoResumen> {
  late FiltroPeriodoResumen _filtro;
  static final _displayDate = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _filtro = widget.initial;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final range = _filtro.resolveRange();
    final initial = isStart ? range.start : range.end;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      var start = isStart ? picked : (_filtro.startDate ?? range.start);
      var end = isStart ? (_filtro.endDate ?? range.end) : picked;
      if (end.isBefore(start)) {
        if (isStart) {
          end = start;
        } else {
          start = end;
        }
      }
      _filtro = FiltroPeriodoResumen(
        periodo: PeriodoResumenVentas.personalizado,
        startDate: start,
        endDate: end,
      );
    });
  }

  void _selectPreset(PeriodoResumenVentas periodo) {
    setState(() {
      if (periodo == PeriodoResumenVentas.personalizado) {
        final range = _filtro.resolveRange();
        _filtro = FiltroPeriodoResumen(
          periodo: PeriodoResumenVentas.personalizado,
          startDate: _filtro.startDate ?? range.start,
          endDate: _filtro.endDate ?? range.end,
        );
      } else {
        _filtro = FiltroPeriodoResumen(periodo: periodo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final range = _filtro.resolveRange();
    final isCustom = _filtro.periodo == PeriodoResumenVentas.personalizado;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filtro de fechas', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final p in const [
                PeriodoResumenVentas.hoy,
                PeriodoResumenVentas.ultimoMes,
                PeriodoResumenVentas.anioActual,
                PeriodoResumenVentas.personalizado,
              ])
                ChoiceChip(
                  label: Text(p.label),
                  selected: _filtro.periodo == p,
                  onSelected: (_) => _selectPreset(p),
                  selectedColor: AppColors.primaryLight,
                  labelStyle: AppTextStyles.label.copyWith(
                    color: _filtro.periodo == p
                        ? AppColors.primaryDark
                        : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: _filtro.periodo == p
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                  showCheckmark: false,
                ),
            ],
          ),
          if (isCustom) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('Rango de fechas', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.sm),
            FilaRangoFechas(
              startLabel: 'Desde',
              endLabel: 'Hasta',
              startValue: _displayDate.format(
                _filtro.startDate ?? range.start,
              ),
              endValue: _displayDate.format(_filtro.endDate ?? range.end),
              onPickStart: () => _pickDate(isStart: true),
              onPickEnd: () => _pickDate(isStart: false),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Aplicar filtro',
            icon: Icons.check_rounded,
            onPressed: () => Navigator.of(context).pop(_filtro),
          ),
        ],
      ),
    );
  }
}
