// Basic smoke test for the Sporto app.
//
// Verifies that the app boots into the splash screen without throwing,
// since the app has no counter or backend logic to test yet.

import 'package:flutter_test/flutter_test.dart';

import 'package:sporto/main.dart';

void main() {
  testWidgets('App boots and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SportoApp());

    expect(find.text('SPORTO'), findsOneWidget);
    expect(find.text('Play. Track. Compete.'), findsOneWidget);

    // Let the splash screen's auto-navigation timer fire and settle so no
    // timers are left pending when the test tree is disposed.
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
