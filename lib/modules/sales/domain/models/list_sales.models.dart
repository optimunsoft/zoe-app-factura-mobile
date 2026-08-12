// Modelos de listado de ventas (GET getAll).

/// Query params de GET listado de ventas.
class ListSalesQuery {
  ListSalesQuery({
    this.page = '1',
    this.amount = '10',
    this.branchId,
    this.thirdPartyId,
    this.documentNumber,
    this.paymentForm,
    this.startDate,
    this.endDate,
  });

  /// `page` — requerido.
  final String page;

  /// `amount` — requerido.
  final String amount;

  /// `id_sucursal` — opcional.
  final String? branchId;

  /// `id_tercero` — opcional.
  final String? thirdPartyId;

  /// `nro_documento` — opcional.
  final String? documentNumber;

  /// `forma_pago` — opcional.
  final String? paymentForm;

  /// `fecha_inicio` — opcional.
  final String? startDate;

  /// `fecha_fin` — opcional.
  final String? endDate;

  int get pageNumber => int.tryParse(page) ?? 1;
  int get pageSize => int.tryParse(amount) ?? 10;

  ListSalesQuery copyWith({
    String? page,
    String? amount,
    String? branchId,
    String? thirdPartyId,
    String? documentNumber,
    String? paymentForm,
    String? startDate,
    String? endDate,
    bool clearBranchId = false,
    bool clearThirdPartyId = false,
    bool clearDocumentNumber = false,
    bool clearPaymentForm = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return ListSalesQuery(
      page: page ?? this.page,
      amount: amount ?? this.amount,
      branchId: clearBranchId ? null : (branchId ?? this.branchId),
      thirdPartyId:
          clearThirdPartyId ? null : (thirdPartyId ?? this.thirdPartyId),
      documentNumber:
          clearDocumentNumber ? null : (documentNumber ?? this.documentNumber),
      paymentForm: clearPaymentForm ? null : (paymentForm ?? this.paymentForm),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  Map<String, dynamic> toQueryMap() {
    return <String, dynamic>{
      'page': page,
      'amount': amount,
      if (branchId != null && branchId!.isNotEmpty) 'id_sucursal': branchId,
      if (thirdPartyId != null && thirdPartyId!.isNotEmpty)
        'id_tercero': thirdPartyId,
      if (documentNumber != null && documentNumber!.isNotEmpty)
        'nro_documento': documentNumber,
      if (paymentForm != null && paymentForm!.isNotEmpty)
        'forma_pago': paymentForm,
      if (startDate != null && startDate!.isNotEmpty) 'fecha_inicio': startDate,
      if (endDate != null && endDate!.isNotEmpty) 'fecha_fin': endDate,
    };
  }
}

/// Resultado paginado de GET /ventas/listar.
class ListSalesPageResult {
  ListSalesPageResult({
    required this.data,
    this.currentPage = 1,
    this.totalPage = 1,
    this.totalRecords = 0,
    this.hasMore = false,
  });

  final List<ListSales> data;
  final int currentPage;
  final int totalPage;
  final int totalRecords;

  /// `true` si la página vino completa o el meta indica más registros.
  final bool hasMore;

  factory ListSalesPageResult.fromResponse(
    dynamic raw, {
    required int requestedPage,
    required int pageSize,
  }) {
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final listRaw = map['data'] ?? map['items'] ?? map['ventas'];
      final list = listRaw is List
          ? listRaw
              .whereType<Map>()
              .map((e) => ListSales.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <ListSales>[];

      final currentPage = _asInt(map['current_page']) ??
          _asInt(map['page']) ??
          requestedPage;
      final totalRecords = _asInt(map['total_records']) ??
          _asInt(map['total']) ??
          0;
      final explicitTotalPage =
          _asInt(map['total_page']) ?? _asInt(map['total_pages']);

      final totalPage = explicitTotalPage != null && explicitTotalPage > 0
          ? explicitTotalPage
          : totalRecords > 0
              ? ((totalRecords + pageSize - 1) ~/ pageSize).clamp(1, 999999)
              : (list.length >= pageSize ? currentPage + 1 : currentPage);

      final hasMore = totalRecords > 0
          ? (requestedPage * pageSize) < totalRecords
          : list.length >= pageSize;

      return ListSalesPageResult(
        data: list,
        currentPage: currentPage,
        totalPage: totalPage < 1 ? 1 : totalPage,
        totalRecords: totalRecords,
        hasMore: hasMore,
      );
    }

    if (raw is List) {
      final list = raw
          .whereType<Map>()
          .map((e) => ListSales.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final hasMore = list.length >= pageSize;
      return ListSalesPageResult(
        data: list,
        currentPage: requestedPage,
        totalPage: hasMore ? requestedPage + 1 : requestedPage,
        totalRecords: 0,
        hasMore: hasMore,
      );
    }

    return ListSalesPageResult(
      data: const [],
      currentPage: requestedPage,
      totalPage: requestedPage,
      hasMore: false,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Impuesto dentro de un detalle de venta listada.
class ListSalesTax {
  ListSalesTax({
    required this.code,
    required this.name,
    required this.percentage,
  });

  final String code;
  final String name;
  final num percentage;

  factory ListSalesTax.fromJson(Map<String, dynamic> json) {
    return ListSalesTax(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      percentage: json['percentage'] as num? ?? 0,
    );
  }
}

/// Línea de producto dentro de una venta listada (`detalles`).
class ListSalesDetail {
  ListSalesDetail({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    this.reteIvaId,
    this.reteFuenteId,
    this.reteIcaId,
    this.taxes = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int productId;
  final int? reteIvaId;
  final int? reteFuenteId;
  final int? reteIcaId;
  final List<ListSalesTax> taxes;
  final String name;
  final num quantity;
  final num unitPrice;
  final num discount;
  final String? createdAt;
  final String? updatedAt;

  factory ListSalesDetail.fromJson(Map<String, dynamic> json) {
    final taxesRaw = json['impuestos'];

    return ListSalesDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productId: (json['id_producto'] as num?)?.toInt() ?? 0,
      reteIvaId: (json['id_reteiva'] as num?)?.toInt(),
      reteFuenteId: (json['id_retefuete'] as num?)?.toInt(),
      reteIcaId: (json['id_reteica'] as num?)?.toInt(),
      taxes: taxesRaw is List
          ? taxesRaw
              .whereType<Map>()
              .map((e) => ListSalesTax.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      name: json['nombre']?.toString() ?? '',
      quantity: json['cantidad'] as num? ?? 0,
      unitPrice: json['precio_unitario'] as num? ?? 0,
      discount: json['descuento'] as num? ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

/// Medio de pago dentro de `detalle_pago` de una venta listada.
class ListSalesPaymentDetail {
  ListSalesPaymentDetail({
    required this.amount,
    required this.name,
    required this.paymentMethodId,
  });

  final num amount;
  final String name;
  final int paymentMethodId;

  factory ListSalesPaymentDetail.fromJson(Map<String, dynamic> json) {
    return ListSalesPaymentDetail(
      amount: json['valor'] as num? ?? 0,
      name: json['nombre']?.toString() ?? '',
      paymentMethodId: (json['id_medio_pago'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Ítem de venta del listado getAll.
class ListSales {
  ListSales({
    required this.id,
    required this.userId,
    required this.issuedDocId,
    required this.branchId,
    required this.branchName,
    required this.thirdPartyId,
    required this.documentNumber,
    required this.thirdPartyNit,
    required this.thirdPartyName,
    required this.saleDate,
    required this.paymentForm,
    required this.paymentDetails,
    required this.saleTotal,
    required this.dueDate,
    required this.details,
    this.preInvoiceId,
    this.paymentDays,
    this.purchaseOrder,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final int issuedDocId;
  final int? preInvoiceId;
  final int branchId;
  final String branchName;
  final int thirdPartyId;
  final String documentNumber;
  final String thirdPartyNit;
  final String thirdPartyName;
  final String saleDate;
  final String paymentForm;
  final List<ListSalesPaymentDetail> paymentDetails;

  /// `total_venta` como string decimal (ej. `"193114.00"`).
  final String saleTotal;
  final int? paymentDays;
  final String dueDate;
  final String? purchaseOrder;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final List<ListSalesDetail> details;

  factory ListSales.fromJson(Map<String, dynamic> json) {
    final paymentRaw = json['detalle_pago'];
    final detailsRaw = json['detalles'];

    return ListSales(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['id_usuario'] as num?)?.toInt() ?? 0,
      issuedDocId: (json['id_doc_emitido'] as num?)?.toInt() ?? 0,
      preInvoiceId: (json['id_prefactura'] as num?)?.toInt(),
      branchId: (json['id_sucursal'] as num?)?.toInt() ?? 0,
      branchName: json['nombre_sucursal']?.toString() ?? '',
      thirdPartyId: (json['id_tercero'] as num?)?.toInt() ?? 0,
      documentNumber: json['nro_documento']?.toString() ?? '',
      thirdPartyNit: json['nit_tercero']?.toString() ?? '',
      thirdPartyName: json['nombre_tercero']?.toString() ?? '',
      saleDate: json['fecha_venta']?.toString() ?? '',
      paymentForm: json['forma_pago']?.toString() ?? '',
      paymentDetails: paymentRaw is List
          ? paymentRaw
              .whereType<Map>()
              .map(
                (e) => ListSalesPaymentDetail.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : const [],
      saleTotal: json['total_venta']?.toString() ?? '0',
      paymentDays: (json['dias_pago'] as num?)?.toInt(),
      dueDate: json['fecha_vencimiento']?.toString() ?? '',
      purchaseOrder: json['orden_compra']?.toString(),
      notes: json['observaciones']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      details: detailsRaw is List
          ? detailsRaw
              .whereType<Map>()
              .map(
                (e) => ListSalesDetail.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
          : const [],
    );
  }

  double get saleTotalValue => double.tryParse(saleTotal) ?? 0;
}
