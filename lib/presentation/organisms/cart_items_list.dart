import 'package:flutter/material.dart';
import '../../domain/models/cart_item.dart';
import '../molecules/cart_line_item.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    super.key,
    required this.items,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final List<CartItem> items;
  final void Function(CartItem item, int quantity) onQuantityChanged;
  final ValueChanged<CartItem> onRemove;

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

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CartLineItem(
          item: item,
          onQuantityChanged: (qty) => onQuantityChanged(item, qty),
          onRemove: () => onRemove(item),
        );
      },
    );
  }
}
