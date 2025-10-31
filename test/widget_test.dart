// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:casino_companion/main.dart';
import 'package:casino_companion/providers/app_state.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Create app state
    final appState = AppState();
    await appState.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(CasinoCompanionApp(appState: appState));

    // Verify that splash screen is shown
    await tester.pump(const Duration(seconds: 1));
    
    // The app should render without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('App state initializes correctly', () async {
    final appState = AppState();
    await appState.init();
    
    // Verify initial state
    expect(appState.sessions.isEmpty, true);
    expect(appState.bankrolls.isEmpty, true);
  });
}
