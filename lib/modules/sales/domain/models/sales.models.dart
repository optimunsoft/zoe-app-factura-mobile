/// Modelos del dominio de ventas (payload de creación de factura / venta).

/// Cuerpo POST para crear una venta.
class CreateSaleRequest {
  CreateSaleRequest({
    required this.branchId,
    required this.customerId,
    required this.email,
    required this.date,
    required this.dueDate,
    required this.products,
    required this.paymentDetail,
    required this.invoiceTotal,
    this.generalWithholdings = const [],
    this.type = '01',
    this.currency = 'COP',
    this.exchangeRate = '0',
    this.notes = '',
    this.purchaseOrder = '',
    this.dispatchOrder = '',
    this.receptionOrder = '',
  });

  /// `id_sucursal` — requerido.
  final int branchId;

  /// `id_cliente` — requerido.
  final int customerId;

  /// IDs de reteIVA / reteICA (códigos 05 / 07). Ej: `[34, 35]`.
  final List<int> generalWithholdings;

  /// Requerido.
  final String email;

  /// Siempre `"01"` para venta.
  final String type;

  /// `fecha` — requerido (`yyyy-MM-dd HH:mm:ss`).
  final String date;

  /// `fecha_vencimiento` — en contado (`forma = 1`) igual a [date].
  final String dueDate;

  /// Siempre `"COP"`.
  final String currency;

  /// Siempre `"0"`.
  final String exchangeRate;

  /// Requerido; puede ser `""`.
  final String notes;

  final List<SaleProductLine> products;
  final SalePaymentDetail paymentDetail;

  /// Opcionales (pueden ir `""`).
  final String purchaseOrder;
  final String dispatchOrder;
  final String receptionOrder;

  /// `total_factura` — restando retención si aplica.
  final double invoiceTotal;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id_sucursal': branchId,
      'id_cliente': customerId,
      'retenciones_generales': generalWithholdings,
      'email': email,
      'tipo': type,
      'fecha': date,
      'fecha_vencimiento': dueDate,
      'moneda': currency,
      'tasa_cambio': exchangeRate,
      'observaciones': notes,
      'productos': products.map((p) => p.toJson()).toList(),
      'detalle_pago': paymentDetail.toJson(),
      'orden_compra': purchaseOrder,
      'orden_despacho': dispatchOrder,
      'orden_recepcion': receptionOrder,
      'total_factura': invoiceTotal,
    };
  }
}

/// Línea de producto dentro de la venta.
class SaleProductLine {
  SaleProductLine({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.description,
    this.discount = 0,
    this.taxes = const [],
    this.withholdings = const [],
  });

  final int id;
  final int quantity;

  /// `precio_unitario` como string decimal (ej. `"8000.00"`).
  final String unitPrice;

  final num discount;
  final String description;
  final List<SaleProductTax> taxes;

  /// Solo retefuente (código 06). Ej: `[33]`.
  final List<int> withholdings;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'cantidad': quantity,
      'precio_unitario': unitPrice,
      'descuento': discount,
      'descripcion': description,
      'impuestos': taxes.map((t) => t.toJson()).toList(),
      'retenciones': withholdings,
    };
  }
}

/// Impuesto de línea (ej. IVA).
class SaleProductTax {
  SaleProductTax({
    required this.name,
    required this.code,
    required this.percentage,
  });

  final String name;
  final String code;
  final num percentage;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'percentage': percentage,
    };
  }
}

/// `detalle_pago` de la factura.
class SalePaymentDetail {
  SalePaymentDetail({
    required this.paymentForm,
    required this.paymentMethods,
    this.paymentDays,
  });

  /// `forma` — `"1"` = contado.
  final String paymentForm;

  /// `medios_pago`.
  final List<SalePaymentMethodLine> paymentMethods;

  /// `dias_pago` — `null` cuando [paymentForm] es `"1"`.
  final int? paymentDays;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'forma': paymentForm,
      'medios_pago': paymentMethods.map((m) => m.toJson()).toList(),
      'dias_pago': paymentDays,
    };
  }
}

/// Medio de pago aplicado a la venta.
class SalePaymentMethodLine {
  SalePaymentMethodLine({
    required this.paymentMethodId,
    required this.amount,
  });

  final int paymentMethodId;
  final num amount;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id_medio_pago': paymentMethodId,
      'valor': amount,
    };
  }
}

/// Resumen mínimo de una venta (respuestas / listados).
class SaleSummary {
  SaleSummary({
    required this.id,
    required this.total,
    this.status,
  });

  final String id;
  final double total;
  final String? status;

  factory SaleSummary.fromJson(Map<String, dynamic> json) {
    return SaleSummary(
      id: json['id']?.toString() ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString(),
    );
  }
}
