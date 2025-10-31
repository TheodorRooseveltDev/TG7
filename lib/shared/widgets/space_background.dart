import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/premium_theme.dart';

/// EXACT Deep Space Background with 500px Glowing Gradient Orb
/// Radial gradient blue to purple with screen blend mode, 120px blur
class SpaceBackground extends StatefulWidget {
  final Widget child;

  const SpaceBackground({super.key, required this.child});

  @override
  State<SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<SpaceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: PremiumTheme.spaceBackground),
      child: Stack(
        children: [
          // TOP GLOWING ORB (650px at center-top with heavier blur)
          Positioned(
            top: -200,
            left: size.width / 2 - 325, // Center horizontally (650/2)
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 160, // EXACT: Heavier 160px blur for glow effect
                    sigmaY: 160,
                  ),
                  child: Container(
                    width: 650, // EXACT: 650px for larger glow
                    height: 650,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: PremiumTheme.glowingOrbGradient,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // BOTTOM GLOWING ORB (650px at center-bottom with heavier blur)
          Positioned(
            bottom: -200,
            left: size.width / 2 - 325, // Center horizontally (650/2)
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      1.05 - (_scaleAnimation.value - 1.0), // Inverse animation
                  child: child,
                );
              },
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 160, // EXACT: Heavier 160px blur for glow effect
                    sigmaY: 160,
                  ),
                  child: Container(
                    width: 650, // EXACT: 650px for larger glow
                    height: 650,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: PremiumTheme.glowingOrbGradient,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // CENTER DECORATIVE PATTERN (Circle with lines - star burst effect)
          Positioned(
            top: size.height / 2 - 100,
            left: size.width / 2 - 100,
            child: CustomPaint(
              size: const Size(200, 200),
              painter: _StarBurstPainter(),
            ),
          ),

          // Content
          widget.child,
        ],
      ),
    );
  }
}

/// Custom painter for star burst pattern with center circle and radiating lines
class _StarBurstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final circleRadius = 8.0;
    final lineLength = 100.0;
    final lineStartDistance = circleRadius + 15;

    // Paint for filled white circle with reduced opacity
    final circleFillPaint = Paint()
      ..color = Colors.white.withOpacity(0.25) // Reduced from 0.8 to 0.25
      ..style = PaintingStyle.fill;

    // Draw tapered lines (thick near center, thin at ends)
    _drawTaperedLine(
      canvas,
      center,
      lineStartDistance,
      lineLength,
      true,
    ); // Left
    _drawTaperedLine(
      canvas,
      center,
      lineStartDistance,
      lineLength,
      false,
    ); // Right

    // Draw center circle on top
    canvas.drawCircle(center, circleRadius, circleFillPaint);
  }

  void _drawTaperedLine(
    Canvas canvas,
    Offset center,
    double startDistance,
    double length,
    bool isLeft,
  ) {
    final direction = isLeft ? -1 : 1;
    final segments = 20; // Number of segments for smooth taper

    for (int i = 0; i < segments; i++) {
      final progress = i / segments;
      final nextProgress = (i + 1) / segments;

      // Calculate thickness - thick at start (near center), thin at end
      final thickness = 6.0 * (1 - progress * 0.8); // Goes from 6 to ~1.2

      final startX =
          center.dx + direction * (startDistance + length * progress);
      final endX =
          center.dx + direction * (startDistance + length * nextProgress);

      final linePaint = Paint()
        ..color = Colors.white.withOpacity(0.25) // Reduced from 0.8 to 0.25
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(startX, center.dy),
        Offset(endX, center.dy),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
