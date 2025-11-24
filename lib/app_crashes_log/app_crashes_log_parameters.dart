import 'package:casino_companion/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String appCrashesLogOneSignalString = "fb244be3-6d40-4c3f-a46e-cbfb3999b59a";
String appCrashesLogDevKeypndAppId = "6754695750";

String appCrashesLogAfDevKey1 = "hNYE575rnPs";
String appCrashesLogAfDevKey2 = "XhWgTXMRzpB";

String appCrashesLogUrl = 'https://casinocompaniontracker.com/appcrasheslog/';
String appCrashesLogStandartWord = "appcrasheslog";

void appCrashesLogOpenStandartAppLogic(BuildContext context) async {
  final appState = context.read<AppState>();

  // Check if user has completed onboarding
  final hasCompletedOnboarding = appState.preferences.hasCompletedOnboarding;

  if (hasCompletedOnboarding) {
    // Navigate to main screen
    Navigator.pushReplacementNamed(context, '/main');
  } else {
    // Navigate to onboarding
    Navigator.pushReplacementNamed(context, '/onboarding');
  }
}

