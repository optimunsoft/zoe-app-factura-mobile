import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/customer.dart';
import '../../../modules/categories/domain/models/categories_models.dart';
import '../../../modules/categories/store/categories.store.dart';
import '../../../modules/products/domain/models/products.models.dart';
import '../../../modules/products/store/products.store.dart';
import '../../molecules/barra_busqueda_escaner.dart';
import '../../organisms/grilla_productos.dart';
import 'widgets/boton_icono_carrito.dart';
import 'widgets/pastilla_categoria.dart';
import 'widgets/encabezado_acordeon_cliente.dart';
import 'widgets/barra_resumen_pedido.dart';

/// Pantalla principal del catálogo de productos POS.
class CatalogoProductosPage extends StatefulWidget {
  const CatalogoProductosPage({
    super.key,
    required this.onReviewPay,
    this.onChangeCustomer,
  });

  final VoidCallback onReviewPay;
  final VoidCallback? onChangeCustomer;

  @override
  State<CatalogoProductosPage> createState() => _CatalogoProductosPageState();
}

class _CatalogoProductosPageState extends State<CatalogoProductosPage> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  bool _customerExpanded = false;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesStore>().loadCategories();
      _loadProducts();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final sucursalId = context.read<AuthController>().user?.sucursalId;
    if (sucursalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay sucursal asociada al usuario')),
      );
      return;
    }

    await context.read<ProductsStore>().loadProducts(
      query: ProductQuery(idSucursal: sucursalId),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      context.read<ProductsStore>().setSearchQuery(value);
    });
  }

  void _selectCategory(Category? category) {
    setState(() => _selectedCategory = category);
    context.read<ProductsStore>().setCategoryFilter(category?.id);
  }

  double _appBarHeight(Customer? customer) {
    var h = kToolbarHeight;
    if (customer != null) {
      h += _customerExpanded ? 300 : 56;
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
    final posCtrl = context.watch<PosController>();
    final productsStore = context.watch<ProductsStore>();
    final customer = posCtrl.activeCustomer;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight(customer)),
        child: Material(
          color:
              Theme.of(context).appBarTheme.backgroundColor ??
              AppColors.surface,
          elevation: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (customer != null)
                    EncabezadoAcordeonCliente(
                      customer: customer,
                      onChangeCustomer: widget.onChangeCustomer,
                      onExpandedChanged: (expanded) {
                        setState(() => _customerExpanded = expanded);
                      },
                    ),
                  SizedBox(
                    height: kToolbarHeight - 8,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Catálogo de productos',
                            style: AppTextStyles.h2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        BotonIconoCarrito(
                          itemCount: posCtrl.itemCount,
                          onPressed: posCtrl.itemCount > 0
                              ? widget.onReviewPay
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: BarraBusquedaEscaner(
              controller: _searchCtrl,
              hint: 'Buscar por nombre o código de barras…',
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final store = context.watch<CategoriesStore>();

              if (store.isLoading) {
                return const SizedBox(
                  height: 42,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              return SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    PastillaCategoria(
                      label: 'Todos',
                      selected: _selectedCategory == null,
                      onTap: () => _selectCategory(null),
                    ),
                    ...store.items.map(
                      (c) => PastillaCategoria(
                        label: c.name,
                        selected: _selectedCategory?.id == c.id,
                        onTap: () => _selectCategory(c),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GrillaProductos(
              posCtrl: posCtrl,
              store: productsStore,
              onRetry: _loadProducts,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraResumenPedido(
        itemCount: posCtrl.itemCount,
        total: posCtrl.total,
        onReviewPay: widget.onReviewPay,
      ),
    );
  }
}

/// Alias de compatibilidad con imports anteriores.
typedef PosCatalogPage = CatalogoProductosPage;
