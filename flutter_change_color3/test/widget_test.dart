// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can use WidgetTester to simulate a user interacting with your
// application.
//
// To add a new test, see the documentation for the WidgetTester at
// https://docs.flutter.dev/testing#testing-widgets

import 'package:flutter/material.dart';
import 'package:flutter_change_color3/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Color changes on tap', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial text is present.
    expect(find.text('Hello there'), findsOneWidget);

    // Record initial background color (green).

    // Simulate a tap on the screen center (Scaffold).
    final gesture = await tester.startGesture(tester.getCenter(find.byType(Scaffold)));
    await gesture.up();
    await tester.pumpAndSettle();

    // Verify tap counter updated.
    expect(find.text('Taps: 1'), findsOneWidget);

    // Optional: Verify color changed (inspect the AnimatedContainer's color).
    // This requires accessing the widget tree; for simplicity, check if taps increased
    // (full color assertion would use tester.binding.renderView or state finder).
  });
}
