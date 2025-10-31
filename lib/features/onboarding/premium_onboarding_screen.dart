import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/premium_theme.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';
import '../../models/user_preferences.dart';
import '../main/main_screen.dart';

/// PREMIUM Onboarding Screen with EXACT glass morphism design
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bankrollController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _bankrollController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final name = _nameController.text.trim();
    final bankrollAmount = double.tryParse(_bankrollController.text);

    if (name.isEmpty) {
      _showGlassSnackBar('Please enter your name');
      return;
    }

    if (bankrollAmount == null || bankrollAmount < 0) {
      _showGlassSnackBar('Please enter a valid bankroll amount');
      return;
    }

    final appState = context.read<AppState>();

    appState.updatePreferences(
      UserPreferences(userName: name, hasCompletedOnboarding: true),
    );

    appState.initializeBankroll('Main Bankroll', bankrollAmount);

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  void _showGlassSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PremiumTheme.glassBase,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PremiumTheme.borderGlass),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: SpaceBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildSetupPage(),
                    _buildResponsibleGamingPage(),
                  ],
                ),
              ),

              // Page Indicators
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => _buildIndicator(index)),
                ),
              ),

              // Floating Gradient Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: _buildFloatingGradientButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? PremiumTheme.primaryBlue : PremiumTheme.glassLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFloatingGradientButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: PremiumTheme.bluePurpleGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: PremiumTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _currentPage == 2 ? 'Get Started' : 'Continue',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Transform.translate(
      offset: const Offset(0, -50), // Move entire content up by 50px
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Transform.translate(
              offset: const Offset(0, -25), // Move logo up additional 25px (total 75px)
              child: Image.asset(
                'assets/images/branding/logo-no-bg.png',
                width: 150,
                height: 150,
              ),
            ),

            const SizedBox(height: 23), // Reduced spacing after logo

          // Gradient Title Text
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: const Text(
              'Welcome to\nCasino Companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                height: 1.2,
                letterSpacing: -1,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Glass Description Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: PremiumTheme.glassActionButton,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const Text(
                  'Track your gaming sessions, manage your bankroll, and gain insights into your performance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: PremiumTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSetupPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Title
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: const Text(
              'Let\'s get started',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Tell us a bit about yourself',
            style: TextStyle(fontSize: 16, color: PremiumTheme.textSecondary),
          ),

          const SizedBox(height: 48),

          // Glass Name Input
          _buildGlassTextField(
            controller: _nameController,
            label: 'Your Name',
            hint: 'Enter your name',
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: 24),

          // Glass Bankroll Input
          _buildGlassTextField(
            controller: _bankrollController,
            label: 'Initial Bankroll',
            hint: 'Enter amount',
            icon: Icons.account_balance_wallet_outlined,
            keyboardType: TextInputType.number,
            prefix: '\$ ',
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PremiumTheme.textTertiary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: PremiumTheme.glassActionButton,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: PremiumTheme.textMuted,
                    fontWeight: FontWeight.w300,
                  ),
                  prefixIcon: Icon(icon, color: PremiumTheme.primaryBlue),
                  prefixText: prefix,
                  prefixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibleGamingPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  PremiumTheme.primaryBlue.withOpacity(0.3),
                  PremiumTheme.gradientPurple.withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 48,
              color: PremiumTheme.primaryBlue,
            ),
          ),

          const SizedBox(height: 32),

          // Title
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: const Text(
              'Responsible Gaming',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Glass Cards with tips
          ..._buildResponsibleGamingTips(),
        ],
      ),
    );
  }

  List<Widget> _buildResponsibleGamingTips() {
    final tips = [
      {'icon': Icons.access_time, 'text': 'Set time limits for your sessions'},
      {
        'icon': Icons.account_balance_wallet,
        'text': 'Never gamble more than you can afford to lose',
      },
      {
        'icon': Icons.info_outline,
        'text': 'Track your spending and take breaks',
      },
    ];

    return tips
        .map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: PremiumTheme.glassActionButton,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              PremiumTheme.primaryBlue.withOpacity(0.3),
                              PremiumTheme.gradientPurple.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          tip['icon'] as IconData,
                          color: PremiumTheme.primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          tip['text'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: PremiumTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
