import 'package:flutter/material.dart';
import '../../core/theme/premium_theme.dart';
import '../../shared/widgets/space_background.dart';

/// Splash Screen with animated loader
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Fade in animation (one-time)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutBack,
      ),
    );

    // Infinite rotation animation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Infinite pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
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
      child: Stack(
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
          
          // Rotating gradient circle (infinite)
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
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
              );
            },
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
          
          // Center pulsing dot (infinite)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_pulseController.value * 0.4), // от 0.8 до 1.2
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
      ),
    );
  }
}
