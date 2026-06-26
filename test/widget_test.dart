// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_farm_app_flutter/main.dart';

void main() {
  test('SmartFarmApp widget can be constructed', () {
    const app = SmartFarmApp();
    expect(app, isA<Widget>());
  });

  testWidgets('ProviderScope + MaterialApp renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: Text('Smart Farm'))),
      ),
    );

    expect(find.text('Smart Farm'), findsOneWidget);
  });
}
