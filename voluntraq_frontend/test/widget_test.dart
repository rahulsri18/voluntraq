// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voluntraq_frontend/main.dart';

void main() {
  testWidgets('App smoke test - verifies landing page', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VoluntraQApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    // Verify that the splash/landing page shows the app name.
    expect(find.text('VoluntraQ'), findsWidgets);

    // Verify that the role selector cards are present.
    expect(find.text('Volunteer / Field Worker'), findsOneWidget);
    expect(find.text('NGO Administrator'), findsOneWidget);
  });
}
