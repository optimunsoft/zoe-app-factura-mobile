import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/sales/domain/models/list_sales.models.dart';
import '../../../../modules/third-party/domain/models/third_party_models.dart';
import '../../../../modules/third-party/store/thirdparty.store.dart';
import '../../../atoms/app_button.dart';
import '../../../molecules/search_bar_with_scan.dart';

/// Estado editable de filtros del historial de ventas.
class SalesHistoryFilters {
  SalesHistoryFilters({
    this.documentNumber = '',
    this.startDate,
    this.endDate,
    this.thirdPartyId,
    this.thirdPartyName,
  });

  String documentNumber;
  DateTime? startDate;
  DateTime? endDate;
  String? thirdPartyId;
  String? thirdPartyName;

  bool get hasActiveFilters =>
      documentNumber.trim().isNotEmpty ||
      startDate != null ||
      endDate != null ||
      (thirdPartyId != null && thirdPartyId!.isNotEmpty);

  SalesHistoryFilters copy() => SalesHistoryFilters(
        documentNumber: documentNumber,
        startDate: startDate,
        endDate: endDate,
        thirdPartyId: thirdPartyId,
        thirdPartyName: thirdPartyName,
      );

  void clear() {
    documentNumber = '';
    startDate = null;
    endDate = null;
    thirdPartyId = null;
    thirdPartyName = null;
  }

  /// Siempre incluye [branchId] (sucursal de la sesión).
  ListSalesQuery toQuery({required String? branchId}) {
    final dateFmt = DateFormat('yyyy-MM-dd');
    return ListSalesQuery(
      page: '1',
      amount: '10',
      documentNumber: documentNumber.trim().isEmpty
          ? null
          : documentNumber.trim(),
      startDate: startDate == null ? null : dateFmt.format(startDate!),
      endDate: endDate == null ? null : dateFmt.format(endDate!),
      thirdPartyId: thirdPartyId,
      branchId: branchId,
    );
  }
}

/// Bottom sheet para filtrar el historial de ventas.
class SalesHistoryFiltersSheet extends StatefulWidget {
  const SalesHistoryFiltersSheet({
    super.key,
    required this.initial,
  });

  final SalesHistoryFilters initial;

  static Future<SalesHistoryFilters?> show(
    BuildContext context, {
    required SalesHistoryFilters initial,
  }) {
    return showModalBottomSheet<SalesHistoryFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SalesHistoryFiltersSheet(initial: initial),
    );
  }

  @override
  State<SalesHistoryFiltersSheet> createState() =>
      _SalesHistoryFiltersSheetState();
}

class _SalesHistoryFiltersSheetState extends State<SalesHistoryFiltersSheet> {
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
    final selected = await _ThirdPartyPickerSheet.show(context);
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
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Filtros', style: AppTextStyles.h2),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filters.clear();
                          _docCtrl.clear();
                        });
                      },
                      child: const Text('Limpiar'),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Nro. documento', style: AppTextStyles.label),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _DateTile(
                              label: 'Desde',
                              value: _filters.startDate == null
                                  ? 'Cualquier'
                                  : _displayDate.format(_filters.startDate!),
                              onTap: () => _pickDate(isStart: true),
                              onClear: _filters.startDate == null
                                  ? null
                                  : () => setState(
                                        () => _filters.startDate = null,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _DateTile(
                              label: 'Hasta',
                              value: _filters.endDate == null
                                  ? 'Cualquier'
                                  : _displayDate.format(_filters.endDate!),
                              onTap: () => _pickDate(isStart: false),
                              onClear: _filters.endDate == null
                                  ? null
                                  : () => setState(
                                        () => _filters.endDate = null,
                                      ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text('Tercero', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Material(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _pickThirdParty,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_search_outlined,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _filters.thirdPartyName?.isNotEmpty == true
                                        ? _filters.thirdPartyName!
                                        : 'Buscar cliente / tercero',
                                    style: AppTextStyles.body.copyWith(
                                      color: _filters.thirdPartyName == null
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
                padding: EdgeInsets.fromLTRB(20, 8, 20, 16 + bottom),
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
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(value, style: AppTextStyles.label),
                  ],
                ),
              ),
              if (onClear != null)
                IconButton(
                  tooltip: 'Quitar',
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppColors.textSecondary,
                )
              else
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThirdPartyPickerSheet extends StatefulWidget {
  const _ThirdPartyPickerSheet();

  static Future<ThirdParty?> show(BuildContext context) {
    return showModalBottomSheet<ThirdParty>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ThirdPartyPickerSheet(),
    );
  }

  @override
  State<_ThirdPartyPickerSheet> createState() => _ThirdPartyPickerSheetState();
}

class _ThirdPartyPickerSheetState extends State<_ThirdPartyPickerSheet> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThirdPartyStore>().searchByAny('');
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ThirdPartyStore>().searchByAny(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ThirdPartyStore>();
    final bottom = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: Container(
          height: maxHeight,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Seleccionar tercero', style: AppTextStyles.h2),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWithScan(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  onScan: () {},
                  hint: 'Buscar por nombre o NIT…',
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: store.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : store.items.isEmpty
                        ? Center(
                            child: Text(
                              'Sin resultados',
                              style: AppTextStyles.bodySmall,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(20, 8, 20, 16 + bottom),
                            itemCount: store.items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = store.items[index];
                              final name = item.displayName.isEmpty
                                  ? 'Sin nombre'
                                  : item.displayName;
                              return Material(
                                color: AppColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () =>
                                      Navigator.of(context).pop(item),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(name, style: AppTextStyles.label),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.identificationNumber,
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
