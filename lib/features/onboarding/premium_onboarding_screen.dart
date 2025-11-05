import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/utils/responsive_utils.dart';
import '../../shared/widgets/space_background.dart';
import '../../shared/widgets/custom_toast.dart';
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
    // Validate step 2 (setup page) before allowing to proceed
    if (_currentPage == 1) {
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
    }

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
    CustomToast.show(
      context,
      message: message,
      icon: Icons.warning_amber_rounded,
      isSuccess: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = ResponsiveUtils.isKeyboardVisible(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: SpaceBackground(
        child: SafeArea(
          child: ResponsiveUtils.constrainWidth(
            context,
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), // Disable swipe
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

                // Page Indicators - hide when keyboard is visible
                if (!isKeyboardVisible)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveUtils.spacing(context, 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => _buildIndicator(index)),
                    ),
                  ),

                // Floating Gradient Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.screenHorizontalPadding(context),
                    vertical: isKeyboardVisible ? 12 : 20,
                  ),
                  child: _buildFloatingGradientButton(),
                ),
              ],
            ),
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
        height: ResponsiveUtils.cardHeight(context, 48),
        decoration: BoxDecoration(
          gradient: PremiumTheme.bluePurpleGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: PremiumTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _currentPage == 2 ? 'Get Started' : 'Continue',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, 15),
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
    final padding = ResponsiveUtils.screenHorizontalPadding(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: isTablet ? 40 : 20),
          
          // App Logo - scaled down
          Image.asset(
            'assets/images/branding/logo-no-bg.png',
            width: ResponsiveUtils.iconSize(context, isTablet ? 120 : 100),
            height: ResponsiveUtils.iconSize(context, isTablet ? 120 : 100),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 20)),

          // Gradient Title Text - scaled down
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: Text(
              'Welcome to\nCasino Companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, isTablet ? 36 : 32),
                fontWeight: FontWeight.w200,
                color: Colors.white,
                height: 1.2,
                letterSpacing: -1,
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 20)),

          // Glass Description Card - scaled down
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.padding(context, 18)),
            decoration: PremiumTheme.glassActionButton,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Text(
                  'Track your gaming sessions, manage your bankroll, and gain insights into your performance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    fontWeight: FontWeight.w400,
                    color: PremiumTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: isTablet ? 40 : 20),
        ],
      ),
    );
  }

  Widget _buildSetupPage() {
    final padding = ResponsiveUtils.screenHorizontalPadding(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isTablet ? 40 : 20),
          
          // Gradient Title - scaled down
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: Text(
              'Let\'s get started',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, isTablet ? 32 : 28),
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 8)),

          Text(
            'Tell us a bit about yourself',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: PremiumTheme.textSecondary,
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 32)),

          // Glass Name Input
          _buildGlassTextField(
            controller: _nameController,
            label: 'Your Name *',
            hint: 'Enter your name',
            icon: Icons.person_outline_rounded,
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 20)),

          // Glass Bankroll Input
          _buildGlassTextField(
            controller: _bankrollController,
            label: 'Initial Bankroll *',
            hint: 'Enter amount',
            icon: Icons.account_balance_wallet_outlined,
            keyboardType: TextInputType.number,
            prefix: '\$ ',
          ),
          
          SizedBox(height: isTablet ? 40 : 20),
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
    final isTablet = ResponsiveUtils.isTablet(context);
    final isNumberKeyboard = keyboardType == TextInputType.number;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 13),
            fontWeight: FontWeight.w500,
            color: PremiumTheme.textTertiary,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, 10)),
        Container(
          decoration: PremiumTheme.glassActionButton,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                textInputAction: isNumberKeyboard ? TextInputAction.done : TextInputAction.next,
                onSubmitted: (_) {
                  // Dismiss keyboard when done/next is pressed
                  if (isNumberKeyboard) {
                    FocusScope.of(context).unfocus();
                  }
                },
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, 15),
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, 15),
                    color: PremiumTheme.textMuted,
                    fontWeight: FontWeight.w300,
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: PremiumTheme.primaryBlue,
                    size: ResponsiveUtils.iconSize(context, 20),
                  ),
                  prefixText: prefix,
                  prefixStyle: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, 15),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(
                    ResponsiveUtils.padding(context, isTablet ? 16 : 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibleGamingPage() {
    final padding = ResponsiveUtils.screenHorizontalPadding(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: isTablet ? 40 : 20),
          
          // Icon - scaled down
          Container(
            width: ResponsiveUtils.iconSize(context, isTablet ? 80 : 70),
            height: ResponsiveUtils.iconSize(context, isTablet ? 80 : 70),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  PremiumTheme.primaryBlue.withOpacity(0.3),
                  PremiumTheme.gradientPurple.withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              size: ResponsiveUtils.iconSize(context, isTablet ? 40 : 35),
              color: PremiumTheme.primaryBlue,
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 24)),

          // Title - scaled down
          ShaderMask(
            shaderCallback: (bounds) =>
                PremiumTheme.balanceTextGradient.createShader(bounds),
            child: Text(
              'Responsible Gaming',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, isTablet ? 28 : 24),
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing(context, 24)),

          // Glass Cards with tips - scaled down
          ..._buildResponsibleGamingTips(),
          
          SizedBox(height: isTablet ? 40 : 20),
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
            padding: EdgeInsets.only(
              bottom: ResponsiveUtils.spacing(context, 12),
            ),
            child: Container(
              padding: EdgeInsets.all(ResponsiveUtils.padding(context, 16)),
              decoration: PremiumTheme.glassActionButton,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Row(
                    children: [
                      Container(
                        width: ResponsiveUtils.iconSize(context, 40),
                        height: ResponsiveUtils.iconSize(context, 40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              PremiumTheme.primaryBlue.withOpacity(0.3),
                              PremiumTheme.gradientPurple.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          tip['icon'] as IconData,
                          color: PremiumTheme.primaryBlue,
                          size: ResponsiveUtils.iconSize(context, 20),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.spacing(context, 14)),
                      Expanded(
                        child: Text(
                          tip['text'] as String,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(context, 14),
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
