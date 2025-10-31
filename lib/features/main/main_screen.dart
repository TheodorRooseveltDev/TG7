import 'package:flutter/material.dart';
import '../../shared/widgets/floating_glass_tab_bar.dart';
import '../../shared/widgets/log_session_fab.dart';
import '../home/premium_home_screen_v2.dart';
import '../sessions/premium_sessions_screen.dart';
import '../sessions/widgets/quick_log_modal.dart';
import '../analyze/premium_analyze_screen.dart';
import '../bankroll/premium_bankroll_screen.dart';
import '../more/premium_more_screen.dart';

/// Main screen with floating glass tab bar navigation
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PremiumHomeScreenV2(),
    PremiumSessionsScreen(),
    PremiumAnalyzeScreen(),
    PremiumBankrollScreen(),
    PremiumMoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true, // Allow content behind tab bar
      body: Stack(
        children: [
          // Main content
          IndexedStack(index: _currentIndex, children: _screens),

          // Floating Glass Tab Bar
          FloatingGlassTabBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // Log Session FAB
          LogSessionFAB(
            onPressed: () => _showAddSessionSheet(context),
          ),
        ],
      ),
    );
  }

  void _showAddSessionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickLogModal(),
    );
  }
}
