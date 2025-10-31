import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/premium_theme.dart';
import '../../shared/widgets/space_background.dart';
import '../../providers/app_state.dart';

/// Splash Screen with animated loader
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    // Navigate after 3 seconds
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumTheme.deepNavyCenter,
      body: SpaceBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildCustomLoader(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomLoader() {
    return SizedBox(
      width: 60,
      height: 60,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1500),
        onEnd: () {
          // Trigger rebuild to restart animation
          if (mounted) setState(() {});
        },
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PremiumTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              
              // Rotating gradient circle
              Transform.rotate(
                angle: value * 2 * 3.14159,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        Colors.transparent,
                        PremiumTheme.primaryBlue.withOpacity(0.5),
                        PremiumTheme.primaryBlue,
                        PremiumTheme.gradientPurple,
                        PremiumTheme.primaryBlue,
                        PremiumTheme.primaryBlue.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Inner circle
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PremiumTheme.deepNavyCenter,
                  border: Border.all(
                    color: PremiumTheme.primaryBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              
              // Center pulsing dot
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 1000),
                onEnd: () {
                  if (mounted) setState(() {});
                },
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: PremiumTheme.primaryBlue.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
