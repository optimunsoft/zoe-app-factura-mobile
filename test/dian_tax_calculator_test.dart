import 'package:flutter_test/flutter_test.dart';

import 'package:hello_flutter/domain/models/line_tax_calculator.dart';
import 'package:hello_flutter/domain/models/product.dart';
import 'package:hello_flutter/modules/taxes/domain/models/taxes.models.dart';

void main() {
  const iva19 = ProductTax(
    code: '01',
    name: 'IVA',
    percentage: 19,
  );

  group('LineTaxCalculator DIAN', () {
    test('iva_incluido desglosa base e importe', () {
      final result = LineTaxCalculator.compute(
        unitPrice: 11900,
        quantity: 1,
        taxes: const [iva19],
        ivaIncluido: true,
      );

      expect(result.valorBase, 11900);
      expect(result.baseImponible, closeTo(10000, 0.01));
      expect(result.ivaAmount, closeTo(1900, 0.01));
      expect(result.valorNeto, 11900);
      expect(result.valorNetoSinIva, closeTo(10000, 0.01));
    });

    test('sin iva_incluido suma impuestos al neto', () {
      final result = LineTaxCalculator.compute(
        unitPrice: 10000,
        quantity: 2,
        taxes: const [iva19],
        ivaIncluido: false,
      );

      expect(result.valorBase, 20000);
      expect(result.baseImponible, 20000);
      expect(result.ivaAmount, closeTo(3800, 0.01));
      expect(result.valorNeto, closeTo(23800, 0.01));
      expect(result.valorNetoSinIva, 20000);
    });

    test('descuento reduce base y valueDiscount', () {
      final result = LineTaxCalculator.compute(
        unitPrice: 10000,
        quantity: 1,
        taxes: const [iva19],
        ivaIncluido: false,
        discountPercent: 10,
      );

      expect(result.precioConDescuento, 9000);
      expect(result.valueDiscount, 1000);
      expect(result.baseImponible, 9000);
      expect(result.ivaAmount, closeTo(1710, 0.01));
      expect(result.valorNeto, closeTo(10710, 0.01));
    });

    test('valorNetoSinIva con impuesto no IVA', () {
      const ico = ProductTax(code: '02', name: 'ICO', percentage: 8);
      final result = LineTaxCalculator.compute(
        unitPrice: 10000,
        quantity: 1,
        taxes: const [iva19, ico],
        ivaIncluido: false,
      );

      expect(result.valorNetoSinIva, closeTo(10800, 0.01));
      expect(result.valorNeto, closeTo(12700, 0.01));
    });
  });

  group('TaxRetention factors', () {
    test('ReteICA usa factor 1000 por defecto', () {
      final reteIca = TaxRetention(
        id: 1,
        description: 'ReteICA',
        percentage: '9.66',
        retention: Retention(
          id: 1,
          code: RetentionCodes.reteIca,
          name: 'ReteICA',
          factor: 0,
        ),
      );

      expect(reteIca.effectiveFactor, 1000);
      expect(reteIca.amountOn(1000000), closeTo(9660, 0.01));
    });

    test('ReteIVA usa factor 100 por defecto', () {
      final reteIva = TaxRetention(
        id: 2,
        description: 'ReteIVA',
        percentage: '15',
        retention: Retention(
          id: 2,
          code: RetentionCodes.reteIva,
          name: 'ReteIVA',
          factor: 0,
        ),
      );

      expect(reteIva.effectiveFactor, 100);
      expect(reteIva.amountOn(1900), closeTo(285, 0.01));
    });
  });
}
