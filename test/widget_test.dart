import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('SmartHomeScreen renders header and metrics',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('Quick Modes'), findsOneWidget);
    expect(find.text('Current power usage'), findsOneWidget);
    expect(find.text('Active devices'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Room filter shows only devices in the selected room',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Kitchen').first);
    await tester.pumpAndSettle();

    expect(find.text('Smart Oven'), findsOneWidget);
    expect(find.text('Kitchen Exhaust Fan'), findsOneWidget);
    expect(find.text('Main Living AC'), findsNothing);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}