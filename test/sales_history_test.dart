import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/modules/sales/domain/mappers/sales_history_mapper.dart';
import 'package:hello_flutter/modules/sales/domain/models/list_sales.models.dart';
import 'package:hello_flutter/modules/sales/domain/models/sales_history_filters.dart';
import 'package:hello_flutter/modules/sales/domain/queries/sales_history_query_builder.dart';

void main() {
  group('SalesHistoryQueryBuilder', () {
    test('incluye sucursal y filtros en query', () {
      final filters = SalesHistoryFilters(
        documentNumber: 'FVM6',
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 15),
        thirdPartyId: '42',
      );

      final query = SalesHistoryQueryBuilder.build(
        filters: filters,
        branchId: '7',
        page: 2,
      );

      expect(query.page, '2');
      expect(query.amount, '10');
      expect(query.branchId, '7');
      expect(query.documentNumber, 'FVM6');
      expect(query.startDate, '2026-03-01');
      expect(query.endDate, '2026-03-15');
      expect(query.thirdPartyId, '42');
    });

    test('omite campos vacíos', () {
      final query = SalesHistoryQueryBuilder.build(
        filters: SalesHistoryFilters(),
        branchId: '1',
      );

      expect(query.documentNumber, isNull);
      expect(query.startDate, isNull);
      expect(query.endDate, isNull);
      expect(query.thirdPartyId, isNull);
    });
  });

  group('ListSalesPageResult', () {
    test('hasMore con meta total_records', () {
      final result = ListSalesPageResult.fromResponse(
        {
          'data': [
            {'id': 1, 'nro_documento': 'A', 'total_venta': '100'},
          ],
          'current_page': 1,
          'total_records': 25,
        },
        requestedPage: 1,
        pageSize: 10,
      );

      expect(result.hasMore, isTrue);
      expect(result.data, hasLength(1));
    });

    test('hasMore en lista cruda sin meta', () {
      final result = ListSalesPageResult.fromResponse(
        List.generate(
          10,
          (i) => {'id': i + 1, 'nro_documento': 'D$i', 'total_venta': '10'},
        ),
        requestedPage: 1,
        pageSize: 10,
      );

      expect(result.hasMore, isTrue);
    });

    test('hasMore false cuando página incompleta', () {
      final result = ListSalesPageResult.fromResponse(
        [
          {'id': 1, 'nro_documento': 'A', 'total_venta': '50'},
        ],
        requestedPage: 1,
        pageSize: 10,
      );

      expect(result.hasMore, isFalse);
    });
  });

  group('SalesHistoryMapper', () {
    test('toListItem usa documento y subtítulo', () {
      final sale = ListSales.fromJson({
        'id': 5,
        'nro_documento': 'FVM-001',
        'nombre_tercero': 'ACME SA',
        'fecha_venta': '2026-03-10T14:30:00',
        'forma_pago': 'Efectivo',
        'total_venta': '150000',
      });

      final item = SalesHistoryMapper.toListItem(sale);

      expect(item.id, 5);
      expect(item.documentLabel, 'FVM-001');
      expect(item.customerName, 'ACME SA');
      expect(item.subtitle, contains('Efectivo'));
      expect(item.total, 150000);
    });

    test('toTitleCase formatea palabras', () {
      expect(
        SalesHistoryMapper.toTitleCase('juan perez'),
        'Juan Perez',
      );
    });
  });
}
