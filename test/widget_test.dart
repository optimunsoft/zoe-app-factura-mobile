import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/main.dart';

void main() {
  testWidgets('Login screen renders', (tester) async {
    await tester.pumpWidget(const TiendaATiendaApp());
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 5)); // finish splash
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('BY OPTIMUN'), findsOneWidget);
  });
}
