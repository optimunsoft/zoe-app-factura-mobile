import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/core/utils/currency_format.dart';
import 'package:hello_flutter/modules/method_payments/domain/models/method_payments.models.dart';
import 'package:hello_flutter/presentation/features/medios_pago/widgets/panel_medios_pago.dart';

void main() {
  MethodPayment medio(int id, String name) {
    return MethodPayment(
      id: id,
      name: name,
      officialPaymentMethod: OfficialPaymentMethod(
        id: id,
        name: name,
        code: '$id',
      ),
    );
  }

  testWidgets(
    'Al abrir un medio sin monto, el campo se llena con el pendiente',
    (tester) async {
      final efectivo = medio(1, 'Efectivo');
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PanelMediosPago(
              items: [efectivo],
              controllers: {1: controller},
              lockedIds: const {},
              confirmedAmounts: const {},
              total: 150000,
              onAdd: (_) => true,
              onEdit: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Efectivo'));
      await tester.pumpAndSettle();

      expect(controller.text, CurrencyFormat.formatInput(150000));
      expect(find.byTooltip('Limpiar'), findsOneWidget);
    },
  );

  testWidgets(
    'El botón Limpiar vacía el campo y deja el pendiente como pista',
    (tester) async {
      final efectivo = medio(1, 'Efectivo');
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PanelMediosPago(
              items: [efectivo],
              controllers: {1: controller},
              lockedIds: const {},
              confirmedAmounts: const {},
              total: 25000,
              onAdd: (_) => true,
              onEdit: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Efectivo'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Limpiar'));
      await tester.pump();

      expect(controller.text, isEmpty);
    },
  );
}
