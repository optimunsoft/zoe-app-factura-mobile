import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/pos_controller.dart';
import '../../../domain/models/customer.dart';
import '../../../domain/models/product.dart' as pos;
import '../../../modules/categories/domain/models/categories_models.dart';
import '../../../modules/categories/store/categories.store.dart';
import '../../../modules/products/domain/models/products.models.dart';
import '../../../modules/products/store/products.store.dart';
import 'widgets/category_pill.dart';
import 'widgets/cart_icon_button.dart';
import 'widgets/product_card.dart';
import '../../molecules/search_bar_with_scan.dart';
import 'widgets/customer_accordion_header.dart';
import 'widgets/order_summary_bar.dart';
import 'widgets/product_detail_sheet.dart';

class PosCatalogPage extends StatefulWidget {
  const PosCatalogPage({
    super.key,
    required this.onReviewPay,
    this.onChangeCustomer,
  });

  final VoidCallback onReviewPay;
  final VoidCallback? onChangeCustomer;

  @override
  State<PosCatalogPage> createState() => _PosCatalogPageState();
}

class _PosCatalogPageState extends State<PosCatalogPage> {
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

  pos.Product _toPosProduct(
    Product product, {
    SellingPriceOption? priceOption,
  }) {
    final options = product.sellingPrices.options;
    final option =
        priceOption ??
        (options.isNotEmpty
            ? options.first
            : SellingPriceOption(
                key: 'default',
                label: 'General',
                price: product.sellingPrice,
              ));

    final useCustomPrice = priceOption != null && priceOption.key != 'default';

    return pos.Product(
      id: useCustomPrice
          ? '${product.id}_${option.key}'
          : product.id.toString(),
      baseId: product.id.toString(),
      name: useCustomPrice ? '${product.name} (${option.label})' : product.name,
      price: option.price,
      stock: product.quantity,
      taxes: product.taxes
          .map(
            (t) => pos.ProductTax(
              code: t.code,
              name: t.name,
              percentage: t.percentage,
              base: pos.TaxCalculationBaseX.fromJson(t.base, isIva: t.isIva),
            ),
          )
          .toList(),
    );
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
                    CustomerAccordionHeader(
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
                        CartIconButton(
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
            child: SearchBarWithScan(
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
                    CategoryPill(
                      label: 'Todos',
                      selected: _selectedCategory == null,
                      onTap: () => _selectCategory(null),
                    ),
                    ...store.items.map(
                      (c) => CategoryPill(
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
          Expanded(child: _buildProductsGrid(posCtrl, productsStore)),
        ],
      ),
      bottomNavigationBar: OrderSummaryBar(
        itemCount: posCtrl.itemCount,
        total: posCtrl.total,
        onReviewPay: widget.onReviewPay,
      ),
    );
  }

  Widget _buildProductsGrid(PosController posCtrl, ProductsStore store) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                store.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: AppColors.danger),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _loadProducts,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (store.items.isEmpty) {
      return Center(
        child: Text(
          'No hay productos',
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const crossCount = 2;
        const crossSpacing = 12.0;
        const horizontalPad = 32.0; // 16 + 16
        final cardWidth =
            (constraints.maxWidth - horizontalPad - crossSpacing) / crossCount;

        // Altura exacta del contenido (sin huecos artificiales).
        final cardHeight =
            (cardWidth / ProductCard.imageAspectRatio) +
            ProductCard.fixedBelowImageHeight;
        final aspectRatio = cardWidth / cardHeight;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: crossSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: store.items.length,
          itemBuilder: (context, index) {
            final apiProduct = store.items[index];
            final product = _toPosProduct(apiProduct);
            final qty = posCtrl.quantityOf(product.id);
            return ProductCard(
              product: product,
              quantity: qty,
              maxQuantity: posCtrl.maxQuantityFor(product),
              onTap: () => ProductDetailSheet.show(
                context,
                product: apiProduct,
                onAdd: product.inStock
                    ? (priceOption) {
                        posCtrl.addProduct(
                          _toPosProduct(apiProduct, priceOption: priceOption),
                        );
                      }
                    : null,
              ),
              onAdd: () => posCtrl.addProduct(product),
              onQuantityChanged: (v) => posCtrl.setQuantity(product, v),
            );
          },
        );
      },
    );
  }
}
