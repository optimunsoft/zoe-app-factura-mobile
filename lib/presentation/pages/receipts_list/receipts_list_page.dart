import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../modules/sales/domain/models/list_sales.models.dart';
import '../../../modules/sales/store/sales.store.dart';
import '../../organisms/transaction_list.dart';
import 'widgets/sales_history_filters_sheet.dart';

class ReceiptsListPage extends StatefulWidget {
  const ReceiptsListPage({super.key});

  @override
  State<ReceiptsListPage> createState() => _ReceiptsListPageState();
}

class _ReceiptsListPageState extends State<ReceiptsListPage> {
  final SalesHistoryFilters _filters = SalesHistoryFilters();
  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  String? get _branchId {
    final id = context.read<AuthController>().user?.sucursalId;
    return id == null ? null : '$id';
  }

  ListSalesQuery get _query => _filters.toQuery(branchId: _branchId);

  Future<void> _load() {
    return context.read<SalesStore>().loadListSales(query: _query);
  }

  Future<void> _openFilters() async {
    final result = await SalesHistoryFiltersSheet.show(
      context,
      initial: _filters,
    );
    if (result == null || !mounted) return;
    setState(() {
      _filters.documentNumber = result.documentNumber;
      _filters.startDate = result.startDate;
      _filters.endDate = result.endDate;
      _filters.thirdPartyId = result.thirdPartyId;
      _filters.thirdPartyName = result.thirdPartyName;
    });
    await _load();
  }

  void _clearFilters() {
    setState(_filters.clear);
    _load();
  }

  List<_FilterChipData> get _activeChips {
    final chips = <_FilterChipData>[];
    final doc = _filters.documentNumber.trim();
    if (doc.isNotEmpty) {
      chips.add(_FilterChipData(label: 'Doc: $doc', onClear: () {
        setState(() => _filters.documentNumber = '');
        _load();
      }));
    }
    if (_filters.startDate != null) {
      chips.add(_FilterChipData(
        label: 'Desde ${_dateFmt.format(_filters.startDate!)}',
        onClear: () {
          setState(() => _filters.startDate = null);
          _load();
        },
      ));
    }
    if (_filters.endDate != null) {
      chips.add(_FilterChipData(
        label: 'Hasta ${_dateFmt.format(_filters.endDate!)}',
        onClear: () {
          setState(() => _filters.endDate = null);
          _load();
        },
      ));
    }
    if (_filters.thirdPartyName != null &&
        _filters.thirdPartyName!.isNotEmpty) {
      chips.add(_FilterChipData(
        label: _filters.thirdPartyName!,
        onClear: () {
          setState(() {
            _filters.thirdPartyId = null;
            _filters.thirdPartyName = null;
          });
          _load();
        },
      ));
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final chips = _activeChips;

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de ventas', style: AppTextStyles.h2),
        actions: [
          IconButton(
            tooltip: 'Filtros',
            onPressed: _openFilters,
            icon: Badge(
              isLabelVisible: _filters.hasActiveFilters,
              smallSize: 8,
              child: const Icon(Icons.tune_rounded),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            if (chips.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ...chips.map(
                    (c) => InputChip(
                      label: Text(c.label, style: AppTextStyles.caption),
                      onDeleted: c.onClear,
                      deleteIconColor: AppColors.primary,
                      backgroundColor: AppColors.primaryLight,
                      side: BorderSide.none,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            const TransactionList(autoLoad: false),
          ],
        ),
      ),
    );
  }
}

class _FilterChipData {
  const _FilterChipData({required this.label, required this.onClear});

  final String label;
  final VoidCallback onClear;
}
