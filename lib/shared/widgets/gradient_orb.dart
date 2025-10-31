import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

/// Animated gradient orb for atmospheric background effects
///
/// Features:
/// - Radial gradient from color to transparent
/// - Heavy Gaussian blur (100px+)
/// - Floating animation with transform3d
/// - Multiple orbs can be layered
class GradientOrb extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final List<double> stops;
  final Duration duration;
  final Offset startOffset;
  final Offset endOffset;
  final double opacity;
  final double blur;

  const GradientOrb({
    Key? key,
    this.size = 400.0,
    this.colors = AppColors.backgroundOrbGradient,
    this.stops = AppColors.backgroundOrbStops,
    this.duration = const Duration(seconds: 20),
    this.startOffset = const Offset(-0.2, -0.3),
    this.endOffset = const Offset(0.2, 0.3),
    this.opacity = 0.3,
    this.blur = AppBlur.orbBlur,
  }) : super(key: key);

  @override
  State<GradientOrb> createState() => _GradientOrbState();
}

class _GradientOrbState extends State<GradientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: widget.startOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _offsetAnimation.value.dx * 100,
            _offsetAnimation.value.dy * 100,
          ),
          child: child,
        );
      },
      child: Opacity(
        opacity: widget.opacity,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: widget.colors,
                stops: widget.stops,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Background with multiple gradient orbs
class GradientOrbBackground extends StatelessWidget {
  final Widget child;
  final bool showOrbs;

  const GradientOrbBackground({
    Key? key,
    required this.child,
    this.showOrbs = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showOrbs) {
      return child;
    }

    return Stack(
      children: [
        // Primary orb - top left
        const Positioned(
          top: -200,
          left: -200,
          child: GradientOrb(
            size: 400,
            duration: Duration(seconds: 20),
            startOffset: Offset(-0.2, -0.3),
            endOffset: Offset(0.2, 0.3),
            opacity: 0.3,
          ),
        ),
        // Secondary orb - bottom right
        const Positioned(
          bottom: -150,
          right: -150,
          child: GradientOrb(
            size: 300,
            colors: [Color(0xFF2B5CE6), Color(0xFF4A7FFF), Color(0x00000000)],
            stops: [0.0, 0.4, 1.0],
            duration: Duration(seconds: 25),
            startOffset: Offset(0.3, 0.2),
            endOffset: Offset(-0.3, -0.2),
            opacity: 0.25,
            blur: 80,
          ),
        ),
        // Tertiary orb - middle right
        const Positioned(
          top: 200,
          right: -100,
          child: GradientOrb(
            size: 250,
            colors: [Color(0xFF4AA8FF), Color(0x00000000)],
            stops: [0.0, 1.0],
            duration: Duration(seconds: 30),
            startOffset: Offset(0.1, -0.2),
            endOffset: Offset(-0.1, 0.2),
            opacity: 0.2,
            blur: 90,
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

/// Shimmer effect for light leak
class ShimmerOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const ShimmerOverlay({Key? key, required this.child, this.enabled = true})
    : super(key: key);

  @override
  State<ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: ShimmerPainter(animation: _animation.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Custom painter for shimmer effect
class ShimmerPainter extends CustomPainter {
  final double animation;

  ShimmerPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [
          Colors.transparent,
          Color(0x33FFFFFF), // rgba(255, 255, 255, 0.2)
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(animation * 3.14159),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.overlay;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

/// Noise texture overlay
class NoiseOverlay extends StatelessWidget {
  final Widget child;
  final double opacity;

  const NoiseOverlay({Key? key, required this.child, this.opacity = 0.03})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(painter: NoisePainter()),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for noise texture
class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // This is a placeholder - in production, you'd use an actual noise texture
    // or generate noise programmatically
    final paint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.overlay;

    // Simple grain simulation
    for (var i = 0; i < 1000; i++) {
      final x = (i * 17) % size.width;
      final y = (i * 23) % size.height;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(NoisePainter oldDelegate) => false;
}
