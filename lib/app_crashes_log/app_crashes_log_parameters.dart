import 'package:casino_companion/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String appCrashesLogOneSignalString = "fb244be3-6d40-4c3f-a46e-cbfb3999b59a";
String afDevKey1 = "hNYE575rnPs";
String afDevKey2 = "XhWgTXMRzpB";

String urlAppCrashesLogLink = "https://casinocompaniontracker.com/appcrasheslog/";

String appCrashesLogParameter = "appcrasheslog";

String devKeypndAppId = "6754695750";

void openStandartAppLogic(BuildContext context) async {

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
