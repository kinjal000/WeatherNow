import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_now/main.dart';

void main() {
  testWidgets('WeatherNow app smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(const WeatherNowApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Login Screen branding
    expect(find.text('WeatherNow'), findsOneWidget);

    // Tap Guest Login Button
    final guestButton = find.byType(OutlinedButton);
    expect(guestButton, findsOneWidget);
    await tester.tap(guestButton);
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Dashboard displays
    expect(find.text('Popular Locations'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
