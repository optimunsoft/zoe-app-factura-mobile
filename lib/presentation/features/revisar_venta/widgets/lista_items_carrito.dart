import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/pos_controller.dart';
import '../../../../domain/models/cart_item.dart';
import 'linea_item_carrito.dart';

class ListaItemsCarrito extends StatelessWidget {
  const ListaItemsCarrito({
    super.key,
    required this.items,
    required this.onQuantityChanged,
    required this.onRemove,
    this.padding,
  });

  final List<CartItem> items;
  final void Function(CartItem item, int quantity) onQuantityChanged;
  final ValueChanged<CartItem> onRemove;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('El carrito está vacío'),
        ),
      );
    }

    final pos = context.watch<PosController>();

    return ListView.builder(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return LineaItemCarrito(
          item: item,
          maxQuantity: pos.maxQuantityFor(item.product),
          onQuantityChanged: (qty) => onQuantityChanged(item, qty),
          onRemove: () => onRemove(item),
        );
      },
    );
  }
}

/// Alias legacy — usar [ListaItemsCarrito].
typedef CartItemsList = ListaItemsCarrito;
