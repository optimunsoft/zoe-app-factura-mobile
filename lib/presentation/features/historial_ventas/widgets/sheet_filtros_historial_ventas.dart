import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/sales_history_filters.dart';
import '../../../atoms/app_button.dart';
import '../../../molecules/fila_rango_fechas.dart';
import '../../../molecules/sheet_selector_tercero.dart';
import '../../../organisms/sheet_inferior_app.dart';

/// Bottom sheet para filtrar el historial de ventas.
class SheetFiltrosHistorialVentas extends StatefulWidget {
  const SheetFiltrosHistorialVentas({
    super.key,
    required this.initial,
  });

  final SalesHistoryFilters initial;

  static Future<SalesHistoryFilters?> show(
    BuildContext context, {
    required SalesHistoryFilters initial,
  }) {
    return SheetInferiorApp.show<SalesHistoryFilters>(
      context,
      maxHeightFactor: 0.9,
      child: SheetFiltrosHistorialVentas(initial: initial),
    );
  }

  @override
  State<SheetFiltrosHistorialVentas> createState() =>
      _SheetFiltrosHistorialVentasState();
}

class _SheetFiltrosHistorialVentasState
    extends State<SheetFiltrosHistorialVentas> {
  late final SalesHistoryFilters _filters;
  late final TextEditingController _docCtrl;
  static final _displayDate = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _filters = widget.initial.copy();
    _docCtrl = TextEditingController(text: _filters.documentNumber);
  }

  @override
  void dispose() {
    _docCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart
        ? (_filters.startDate ?? DateTime.now())
        : (_filters.endDate ?? _filters.startDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _filters.startDate = picked;
        if (_filters.endDate != null && _filters.endDate!.isBefore(picked)) {
          _filters.endDate = picked;
        }
      } else {
        _filters.endDate = picked;
        if (_filters.startDate != null &&
            _filters.startDate!.isAfter(picked)) {
          _filters.startDate = picked;
        }
      }
    });
  }

  Future<void> _pickThirdParty() async {
    final selected = await SheetSelectorTercero.show(context);
    if (selected == null || !mounted) return;
    setState(() {
      _filters.thirdPartyId = '${selected.id}';
      _filters.thirdPartyName = selected.displayName.isEmpty
          ? selected.identificationNumber
          : selected.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.sm, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('Filtros', style: AppTextStyles.h2),
                ),
                AppButton(
                  label: 'Limpiar',
                  expanded: false,
                  height: 28,
                  compact: true,
                  variant: AppButtonVariant.primary,
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                      _docCtrl.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Nro. documento', style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _docCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Ej. FVM6',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    onChanged: (v) => _filters.documentNumber = v,
                  ),
                  const SizedBox(height: 18),
                  Text('Rango de fechas', style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.sm),
                  FilaRangoFechas(
                    startLabel: 'Desde',
                    endLabel: 'Hasta',
                    startValue: _filters.startDate == null
                        ? 'Cualquier'
                        : _displayDate.format(_filters.startDate!),
                    endValue: _filters.endDate == null
                        ? 'Cualquier'
                        : _displayDate.format(_filters.endDate!),
                    onPickStart: () => _pickDate(isStart: true),
                    onPickEnd: () => _pickDate(isStart: false),
                    onClearStart: _filters.startDate == null
                        ? null
                        : () => setState(() => _filters.startDate = null),
                    onClearEnd: _filters.endDate == null
                        ? null
                        : () => setState(() => _filters.endDate = null),
                  ),
                  const SizedBox(height: 18),
                  Text('Tercero', style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.sm),
                  Material(
                    color: AppColors.surfaceAlt,
                    borderRadius: AppRadius.mdAll,
                    child: InkWell(
                      onTap: _pickThirdParty,
                      borderRadius: AppRadius.mdAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.mdAll,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_search_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                _filters.thirdPartyName?.isNotEmpty == true
                                    ? _filters.thirdPartyName!
                                    : 'Buscar cliente / tercero',
                                style: AppTextStyles.body.copyWith(
                                  color: _filters.thirdPartyId == null
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (_filters.thirdPartyId != null)
                              IconButton(
                                tooltip: 'Quitar',
                                onPressed: () => setState(() {
                                  _filters.thirdPartyId = null;
                                  _filters.thirdPartyName = null;
                                }),
                                icon: const Icon(Icons.close_rounded),
                                color: AppColors.textSecondary,
                              )
                            else
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textMuted,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg + bottom,
            ),
            child: AppButton(
              label: 'Aplicar filtros',
              icon: Icons.check_rounded,
              onPressed: () {
                _filters.documentNumber = _docCtrl.text;
                Navigator.of(context).pop(_filters);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Alias legacy — usar [SheetFiltrosHistorialVentas].
typedef SalesHistoryFiltersSheet = SheetFiltrosHistorialVentas;
