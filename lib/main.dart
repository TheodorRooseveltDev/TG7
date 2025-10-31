import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/premium_theme.dart';
import 'features/main/main_screen.dart';
import 'features/onboarding/premium_onboarding_screen.dart';
import 'features/splash/splash_screen.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for premium glass design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize app state with storage
  final appState = AppState();
  await appState.init();

  runApp(CasinoCompanionApp(appState: appState));
}

class CasinoCompanionApp extends StatelessWidget {
  final AppState appState;
  
  const CasinoCompanionApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        title: 'Casino Companion',
        debugShowCheckedModeBanner: false,
        theme: PremiumTheme.themeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
