import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/core/layout/area_segura.dart';

void main() {
  Future<void> pumpSurface(
    WidgetTester tester, {
    required Widget child,
    Size size = const Size(1280, 800),
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets viewPadding = EdgeInsets.zero,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: size,
          padding: padding,
          viewPadding: viewPadding,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      ),
    );
  }

  testWidgets(
    'CuerpoAreaSegura reserva el inset inferior cuando está activo',
    (tester) async {
      await pumpSurface(
        tester,
        padding: const EdgeInsets.only(bottom: 48),
        viewPadding: const EdgeInsets.only(bottom: 48),
        child: const CuerpoAreaSegura(
          activo: true,
          child: SizedBox.expand(child: ColoredBox(color: Color(0xFF000000))),
        ),
      );

      expect(tester.getRect(find.byType(ColoredBox)).bottom, 752);
    },
  );

  testWidgets(
    'CuerpoAreaSegura no reserva espacio si el sistema no reporta barra',
    (tester) async {
      await pumpSurface(
        tester,
        child: const CuerpoAreaSegura(
          activo: true,
          child: SizedBox.expand(child: ColoredBox(color: Color(0xFF000000))),
        ),
      );

      expect(tester.getRect(find.byType(ColoredBox)).bottom, 800);
    },
  );

  testWidgets(
    'CuerpoAreaSegura no envuelve cuando el shell usa nav inferior',
    (tester) async {
      await pumpSurface(
        tester,
        padding: const EdgeInsets.only(bottom: 48),
        viewPadding: const EdgeInsets.only(bottom: 48),
        child: const CuerpoAreaSegura(
          activo: false,
          child: SizedBox.expand(child: ColoredBox(color: Color(0xFF000000))),
        ),
      );

      expect(tester.getRect(find.byType(ColoredBox)).bottom, 800);
    },
  );

  testWidgets('AreaSegura.hayBarraInferior respeta viewPadding', (tester) async {
    late bool hayBarra;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(viewPadding: EdgeInsets.only(bottom: 32)),
        child: Builder(
          builder: (context) {
            hayBarra = AreaSegura.hayBarraInferior(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(hayBarra, isTrue);
  });
}
