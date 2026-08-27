import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/layout/ancho_vista.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/customer.dart';
import '../../../modules/categories/domain/models/categories_models.dart';
import '../../../modules/categories/store/categories.store.dart';
import '../../../modules/products/domain/models/products.models.dart';
import '../../../modules/products/store/products.store.dart';
import '../../atoms/boton_menu_drawer.dart';
import '../../molecules/barra_busqueda_escaner.dart';
import '../../organisms/grilla_productos.dart';
import '../../organisms/plantilla_adaptativa.dart';
import 'widgets/boton_icono_carrito.dart';
import 'widgets/encabezado_acordeon_cliente.dart';
import 'widgets/barra_resumen_pedido.dart';
import 'widgets/lista_filtros_categoria.dart';
import 'widgets/panel_carrito_catalogo.dart';

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
    var h = 72.0;
    if (customer != null) {
      h += _customerExpanded ? 300 : 56;
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
    final posCtrl = context.watch<PosController>();
    final productsStore = context.watch<ProductsStore>();
    final categoriesStore = context.watch<CategoriesStore>();
    final customer = posCtrl.activeCustomer;

    final conCarrito = AnchoVista.usaPanelCarrito(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          _appBarHeight(customer) + MediaQuery.paddingOf(context).top,
        ),
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
                  SizedBox(
                    height: 64,
                    child: Row(
                      children: [
                        if (BotonMenuDrawer.visibleEn(context))
                          const BotonMenuDrawer(compacto: true),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: BotonMenuDrawer.visibleEn(context)
                                  ? 0
                                  : AppSpacing.sm,
                            ),
                            child: Text(
                              'Catálogo de productos',
                              style: AppTextStyles.h2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (!conCarrito)
                          BotonIconoCarrito(
                            itemCount: posCtrl.itemCount,
                            onPressed: posCtrl.itemCount > 0
                                ? widget.onReviewPay
                                : null,
                          ),
                      ],
                    ),
                  ),
                  if (customer != null)
                    EncabezadoAcordeonCliente(
                      customer: customer,
                      onChangeCustomer: widget.onChangeCustomer,
                      onExpandedChanged: (expanded) {
                        setState(() => _customerExpanded = expanded);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: PlantillaDosColumnas(
        activo: conCarrito,
        anchoDetalle: AnchoVista.anchoPanelCarrito(context),
        principal: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AnchoVista.paddingHorizontal(context),
                AppSpacing.sm,
                AnchoVista.paddingHorizontal(context),
                0,
              ),
              child: BarraBusquedaEscaner(
                controller: _searchCtrl,
                hint: 'Buscar por nombre o código de barras…',
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListaFiltrosCategoria(
              categorias: categoriesStore.items,
              seleccionada: _selectedCategory,
              onSeleccionar: _selectCategory,
              cargando: categoriesStore.isLoading,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: GrillaProductos(
                posCtrl: posCtrl,
                store: productsStore,
                onRetry: _loadProducts,
              ),
            ),
          ],
        ),
        detalle: PanelCarritoCatalogo(onReviewPay: widget.onReviewPay),
      ),
      bottomNavigationBar: conCarrito
          ? null
          : BarraResumenPedido(
              itemCount: posCtrl.itemCount,
              total: posCtrl.total,
              onReviewPay: widget.onReviewPay,
            ),
    );
  }
}

/// Alias de compatibilidad con imports anteriores.
typedef PosCatalogPage = CatalogoProductosPage;
