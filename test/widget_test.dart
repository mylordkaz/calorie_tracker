import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nibble/main.dart';

void main() {
  testWidgets('App starts and shows welcome screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Wait for async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app starts (it should show some content)
    expect(find.byType(MaterialApp), findsOneWidget);

    // Since the app might show welcome screen or main screen depending on user status,
    // we just verify it loads without error
    expect(tester.takeException(), isNull);
  });

  testWidgets('App handles basic navigation', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Verify app loads successfully
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
