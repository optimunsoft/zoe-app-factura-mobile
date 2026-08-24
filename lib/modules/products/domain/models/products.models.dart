/// Query params de GET /producto/inventory/branch.
/// Obligatorio: [idSucursal]. Sin filtros de búsqueda en el endpoint.
class ProductQuery {
  ProductQuery({required this.idSucursal});

  final int idSucursal;

  Map<String, dynamic> toQueryMap() {
    return {'id_sucursal': idSucursal};
  }
}

class ProductBranchInfo {
  ProductBranchInfo({required this.id, required this.name});

  final int id;
  final String name;

  factory ProductBranchInfo.fromJson(Map<String, dynamic> json) {
    return ProductBranchInfo(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class ProductCategoryInfo {
  ProductCategoryInfo({required this.id, required this.name});

  final int id;
  final String name;

  factory ProductCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ProductCategoryInfo(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class SellingPrices {
  SellingPrices({
    required this.defaultPrice,
    this.distributor,
    this.wholesaler,
    this.unit,
    this.box,
  });

  final double defaultPrice;
  final double? distributor;
  final double? wholesaler;
  final double? unit;
  final double? box;

  static double? _parse(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory SellingPrices.fromJson(Map<String, dynamic> json) {
    return SellingPrices(
      defaultPrice: _parse(json['default']) ?? 0,
      distributor: _parse(json['distributor']),
      wholesaler: _parse(json['wholesaler']),
      unit: _parse(json['unit']),
      box: _parse(json['box']),
    );
  }

  /// Precios disponibles para seleccionar en el detalle.
  List<SellingPriceOption> get options {
    return [
      SellingPriceOption(
        key: 'default',
        label: 'General',
        price: defaultPrice,
      ),
      if (distributor != null)
        SellingPriceOption(
          key: 'distributor',
          label: 'Distribuidor',
          price: distributor!,
        ),
      if (wholesaler != null)
        SellingPriceOption(
          key: 'wholesaler',
          label: 'Mayorista',
          price: wholesaler!,
        ),
      if (unit != null)
        SellingPriceOption(
          key: 'unit',
          label: 'Unidad',
          price: unit!,
        ),
      if (box != null)
        SellingPriceOption(
          key: 'box',
          label: 'Caja',
          price: box!,
        ),
    ];
  }
}

class SellingPriceOption {
  const SellingPriceOption({
    required this.key,
    required this.label,
    required this.price,
  });

  final String key;
  final String label;
  final double price;

  /// El precio General siempre se puede usar. Las demás listas, solo si > 0.
  bool get seleccionable => key == 'default' || price > 0;
}

class ProductTax {
  ProductTax({
    required this.code,
    required this.name,
    required this.percentage,
    this.base,
  });

  final String code;
  final String name;
  final double percentage;

  /// Base de cálculo: `sin_iva`, `con_iva`, `valor_iva`, `precio`, `total_factura`.
  final String? base;

  bool get isIva {
    final n = name.toUpperCase();
    return code == '01' || n.contains('IVA');
  }

  factory ProductTax.fromJson(Map<String, dynamic> json) {
    return ProductTax(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      base: (json['base'] ??
              json['base_calculo'] ??
              json['tax_base'] ??
              json['calculation_base'])
          ?.toString(),
    );
  }
}

/// Ítem de GET /producto/inventory/branch.
class Product {
  Product({
    required this.id,
    required this.idCompany,
    required this.branch,
    required this.category,
    required this.barcode,
    required this.name,
    this.presentation,
    this.reference,
    this.description,
    required this.service,
    required this.productCost,
    required this.sellingPrices,
    required this.quantity,
    required this.taxes,
    required this.productTaxType,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int idCompany;
  final ProductBranchInfo branch;
  final ProductCategoryInfo category;
  final String barcode;
  final String name;
  final String? presentation;
  final String? reference;
  final String? description;
  final bool service;
  final double productCost;
  final SellingPrices sellingPrices;
  final int quantity;
  final List<ProductTax> taxes;
  final String productTaxType;
  final String? createdAt;
  final String? updatedAt;

  double get sellingPrice => sellingPrices.defaultPrice;
  int get stock => quantity;
  bool get inStock => quantity > 0;

  /// Código para mostrar en catálogo: barras, si no referencia, si no el id.
  String get displayCode {
    if (barcode.trim().isNotEmpty) return barcode.trim();
    final ref = reference?.trim() ?? '';
    if (ref.isNotEmpty) return ref;
    return id.toString();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final branchRaw = json['branch'];
    final categoryRaw = json['category'];
    final pricesRaw = json['selling_prices'];
    final taxesRaw = json['taxes'];

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      idCompany: (json['id_company'] as num?)?.toInt() ?? 0,
      branch: branchRaw is Map
          ? ProductBranchInfo.fromJson(Map<String, dynamic>.from(branchRaw))
          : ProductBranchInfo(id: 0, name: ''),
      category: categoryRaw is Map
          ? ProductCategoryInfo.fromJson(Map<String, dynamic>.from(categoryRaw))
          : ProductCategoryInfo(id: 0, name: ''),
      barcode: json['barcode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      presentation: json['presentation']?.toString(),
      reference: json['reference']?.toString(),
      description: json['description']?.toString(),
      service: json['service'] == true,
      productCost: (json['product_cost'] as num?)?.toDouble() ?? 0,
      sellingPrices: pricesRaw is Map
          ? SellingPrices.fromJson(Map<String, dynamic>.from(pricesRaw))
          : SellingPrices(defaultPrice: 0),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      taxes: taxesRaw is List
          ? taxesRaw
              .whereType<Map>()
              .map((e) => ProductTax.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      productTaxType: json['product_tax_type']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
