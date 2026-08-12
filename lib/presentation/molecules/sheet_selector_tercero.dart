import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../modules/third-party/domain/models/third_party_models.dart';
import '../../modules/third-party/store/thirdparty.store.dart';
import 'barra_busqueda_escaner.dart';
import '../organisms/sheet_inferior_app.dart';

/// Selector de tercero reutilizable (búsqueda + lista).
class SheetSelectorTercero extends StatefulWidget {
  const SheetSelectorTercero({super.key});

  static Future<ThirdParty?> show(BuildContext context) {
    return SheetInferiorApp.show<ThirdParty>(
      context,
      maxHeightFactor: 0.85,
      child: const SheetSelectorTercero(),
    );
  }

  @override
  State<SheetSelectorTercero> createState() => _SheetSelectorTerceroState();
}

class _SheetSelectorTerceroState extends State<SheetSelectorTercero> {
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
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.sm, AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text('Seleccionar tercero', style: AppTextStyles.h2),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: BarraBusquedaEscaner(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              onScan: () {},
              hint: 'Buscar por nombre o NIT…',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
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
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.lg + bottom,
                        ),
                        itemCount: store.items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = store.items[index];
                          final name = item.displayName.isEmpty
                              ? 'Sin nombre'
                              : item.displayName;
                          return Material(
                            color: AppColors.surfaceAlt,
                            borderRadius: AppRadius.mdAll,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(item),
                              borderRadius: AppRadius.mdAll,
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

/// Alias legacy — usar [SheetSelectorTercero].
typedef ThirdPartyPickerSheet = SheetSelectorTercero;
