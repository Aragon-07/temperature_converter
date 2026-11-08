import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:temperature_converter/main.dart';

void main() {
  testWidgets('Temperature Converter renders initial state and converts values',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    // Verify initial UI elements and defaults
    expect(find.text('Temperature Converter'), findsOneWidget);
    expect(find.text('Degrees'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Result'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);
    expect(find.text('Fahrenheit to Celsius (°F → °C)'), findsOneWidget);
    expect(find.text('Calculate / Convert'), findsOneWidget);

    final Finder textField = find.byType(TextField);
    final Finder calculateButton = find.text('Calculate / Convert');

    // 1. Empty input validation
    await tester.tap(calculateButton);
    await tester.pump();
    expect(find.text('Please enter a temperature value'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);

    // 2. Invalid number input validation
    await tester.enterText(textField, 'abc');
    await tester.tap(calculateButton);
    await tester.pump();
    expect(find.text('Please enter a valid number'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);

    // 3. Valid Fahrenheit to Celsius conversion (default option)
    await tester.enterText(textField, '72');
    await tester.tap(calculateButton);
    await tester.pump();
    expect(find.text('Please enter a valid number'), findsNothing);
    expect(find.text('Please enter a temperature value'), findsNothing);
    expect(find.text('22.22 °C'), findsOneWidget);

    // 4. Switch dropdown to Celsius to Fahrenheit and convert
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Celsius to Fahrenheit (°C → °F)').last);
    await tester.pumpAndSettle();

    await tester.enterText(textField, '100');
    await tester.tap(calculateButton);
    await tester.pump();
    expect(find.text('212.00 °F'), findsOneWidget);
  });
}
