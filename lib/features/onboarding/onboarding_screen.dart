import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/gradient_orb.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/custom_button.dart';
import '../../providers/app_state.dart';
import '../../models/user_preferences.dart';
import '../main/main_screen.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    if (bankrollAmount == null || bankrollAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid bankroll amount')),
      );
      return;
    }

    final appState = context.read<AppState>();

    // Set user preferences
    appState.updatePreferences(
      UserPreferences(userName: name, hasCompletedOnboarding: true),
    );

    // Initialize bankroll
    appState.initializeBankroll('Main Bankroll', bankrollAmount);

    // Navigate to main screen
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: GradientOrbBackground(
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

              // Page indicators and navigation
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xxs,
                          ),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.electricBluePrimary
                                : AppColors.glassBorder,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Navigation button
                    CustomButton(
                      text: _currentPage == 2 ? 'Get Started' : 'Continue',
                      onPressed: _nextPage,
                      style: ButtonStyle.primary,
                      isFullWidth: true,
                    ),

                    if (_currentPage < 2)
                      TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(2);
                        },
                        child: Text(
                          'Skip',
                          style: AppTypography.bodyMStyle(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo
          Image.asset(
            'assets/images/branding/logo-no-bg.png',
            width: 150,
            height: 150,
          ),

          const SizedBox(height: AppSpacing.xxxl),

          Text(
            'Welcome to\nCasino Companion',
            style: AppTypography.displayMStyle(),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Know your game. Play smarter.',
            style: AppTypography.bodyLStyle(
              color: AppColors.electricBluePrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxl),

          SimpleGlassCard(
            child: Column(
              children: [
                _buildFeatureItem(
                  icon: Icons.analytics_outlined,
                  title: 'Track Sessions',
                  description: 'Log every casino visit with detailed analytics',
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFeatureItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Manage Bankroll',
                  description: 'Keep track of your gaming budget',
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFeatureItem(
                  icon: Icons.insights_outlined,
                  title: 'Get Insights',
                  description: 'Understand your patterns and improve',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),

          Text('Let\'s Set You Up', style: AppTypography.displayMStyle()),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Tell us a bit about yourself to get started',
            style: AppTypography.bodyLStyle(color: AppColors.textTertiary),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          SimpleGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What should we call you?',
                  style: AppTypography.bodyLStyle(),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _nameController,
                  style: AppTypography.bodyLStyle(),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: AppTypography.bodyLStyle(
                      color: AppColors.textQuaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(
                        color: AppColors.electricBluePrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                Text(
                  'Initial Bankroll Amount',
                  style: AppTypography.bodyLStyle(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'How much do you want to start tracking?',
                  style: AppTypography.bodyMStyle(
                    color: AppColors.textQuaternary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _bankrollController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.bodyLStyle(),
                  decoration: InputDecoration(
                    hintText: '\$0.00',
                    prefixText: '\$ ',
                    prefixStyle: AppTypography.bodyLStyle(),
                    hintStyle: AppTypography.bodyLStyle(
                      color: AppColors.textQuaternary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      borderSide: BorderSide(
                        color: AppColors.electricBluePrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.electricBluePrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              border: Border.all(
                color: AppColors.electricBluePrimary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.electricBluePrimary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Your data stays private and secure on your device only.',
                    style: AppTypography.bodyMStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibleGamingPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenMarginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),

          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryButtonGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
              ),
              child: const Center(
                child: Text('🛡️', style: TextStyle(fontSize: 56)),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          Text(
            'Responsible Gaming',
            style: AppTypography.displayMStyle(),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Please remember these important points:',
            style: AppTypography.bodyLStyle(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxl),

          SimpleGlassCard(
            child: Column(
              children: [
                _buildResponsibleItem(
                  icon: Icons.local_atm_outlined,
                  title: 'Set Limits',
                  description: 'Only gamble with money you can afford to lose',
                ),
                const Divider(height: 32, color: AppColors.glassBorder),
                _buildResponsibleItem(
                  icon: Icons.schedule_outlined,
                  title: 'Know When to Stop',
                  description: 'Take breaks and never chase losses',
                ),
                const Divider(height: 32, color: AppColors.glassBorder),
                _buildResponsibleItem(
                  icon: Icons.analytics_outlined,
                  title: 'Track Everything',
                  description: 'Use this app to monitor your gaming patterns',
                ),
                const Divider(height: 32, color: AppColors.glassBorder),
                _buildResponsibleItem(
                  icon: Icons.block_outlined,
                  title: 'No Real Money',
                  description:
                      'This is a tracking tool only - not for gambling',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              border: Border.all(
                color: AppColors.warningOrange.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 32,
                  color: AppColors.warningOrange,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'If you feel you have a gambling problem, please seek help immediately.',
                  style: AppTypography.bodyMStyle(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '1-800-GAMBLER',
                  style: AppTypography.bodyLStyle(
                    color: AppColors.warningOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.electricBluePrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: Icon(icon, color: AppColors.electricBluePrimary, size: 24),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyLStyle()),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                description,
                style: AppTypography.bodyMStyle(
                  color: AppColors.textQuaternary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibleItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.electricBluePrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          child: Icon(icon, color: AppColors.electricBluePrimary, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyLStyle()),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                description,
                style: AppTypography.bodyMStyle(
                  color: AppColors.textQuaternary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
