import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_catalog.dart';
import '../../data/pos_controller.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/product.dart';
import '../atoms/category_pill.dart';
import '../molecules/cart_icon_button.dart';
import '../molecules/product_card.dart';
import '../molecules/search_bar_with_scan.dart';
import '../organisms/customer_accordion_header.dart';
import '../organisms/order_summary_bar.dart';

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
  ProductCategory _category = ProductCategory.all;
  String _query = '';
  bool _customerExpanded = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    return MockCatalog.products.where((p) {
      final catOk = _category == ProductCategory.all || p.category == _category;
      final q = _query.trim().toLowerCase();
      final qOk =
          q.isEmpty || p.name.toLowerCase().contains(q) || p.id.contains(q);
      return catOk && qOk;
    }).toList();
  }

  double _appBarHeight(Customer? customer) {
    // Fila cliente compacta + fila título catálogo + holgura anti-overflow
    var h = kToolbarHeight + 44;
    if (customer != null && _customerExpanded) {
      h += 210;
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final customer = pos.activeCustomer;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight(customer)),
        child: Material(
          color: Theme.of(context).appBarTheme.backgroundColor ??
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
                            'Catálogo POS',
                            style: AppTextStyles.h2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        CartIconButton(
                          itemCount: pos.itemCount,
                          onPressed:
                              pos.itemCount > 0 ? widget.onReviewPay : null,
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
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ProductCategory.values
                  .map(
                    (c) => CategoryPill(
                      label: c.label,
                      selected: _category == c,
                      onTap: () => setState(() => _category = c),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final product = _filtered[index];
                final qty = pos.quantityOf(product.id);
                return ProductCard(
                  product: product,
                  quantity: qty,
                  onAdd: () => pos.addProduct(product),
                  onQuantityChanged: (v) => pos.setQuantity(product, v),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: OrderSummaryBar(
        itemCount: pos.itemCount,
        subtotal: pos.subtotal,
        tax: pos.tax,
        total: pos.total,
        onReviewPay: widget.onReviewPay,
      ),
    );
  }
}
