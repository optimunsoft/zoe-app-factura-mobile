enum ProductCategory { all, drinks, snacks, dairy, grocery }

extension ProductCategoryX on ProductCategory {
  String get label => switch (this) {
        ProductCategory.all => 'Todos',
        ProductCategory.drinks => 'Bebidas',
        ProductCategory.snacks => 'Snacks',
        ProductCategory.dairy => 'Lácteos',
        ProductCategory.grocery => 'Abarrotes',
      };
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.emoji,
  });

  final String id;
  final String name;
  final double price;
  final int stock;
  final ProductCategory category;
  final String emoji;

  bool get inStock => stock > 0;
  bool get lowStock => stock > 0 && stock <= 8;
}
