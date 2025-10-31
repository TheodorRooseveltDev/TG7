import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

/// Ultra-detailed animation system for Casino Companion
class AppAnimations {
  AppAnimations._();

  // ============= Timing Functions (Cubic Bezier Curves) =============

  /// Default ease - cubic-bezier(0.4, 0.0, 0.2, 1)
  static const Curve easeDefault = Curves.easeInOut;

  /// Ease in - cubic-bezier(0.4, 0.0, 1, 1)
  static const Curve easeIn = Curves.easeIn;

  /// Ease out - cubic-bezier(0.0, 0.0, 0.2, 1)
  static const Curve easeOut = Curves.easeOut;

  /// Ease in out - cubic-bezier(0.4, 0.0, 0.6, 1)
  static const Curve easeInOut = Curves.easeInOut;

  /// Spring - cubic-bezier(0.34, 1.56, 0.64, 1) - for bouncy effects
  static const Curve spring = Curves.elasticOut;

  /// Custom smooth curve
  static const Curve smooth = Curves.easeInOutCubic;

  // ============= Duration System =============

  /// Instant - 100ms (Micro interactions)
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast - 200ms (Hover states)
  static const Duration fast = Duration(milliseconds: 200);

  /// Normal - 300ms (Standard transitions)
  static const Duration normal = Duration(milliseconds: 300);

  /// Smooth - 400ms (Panel slides)
  static const Duration smoothDuration = Duration(milliseconds: 400);

  /// Slow - 600ms (Page transitions)
  static const Duration slow = Duration(milliseconds: 600);

  /// Dramatic - 800ms (Major reveals)
  static const Duration dramatic = Duration(milliseconds: 800);

  /// Number ticker - 800ms (Balance changes)
  static const Duration numberTicker = Duration(milliseconds: 800);

  /// Loading pulse - 1.5s
  static const Duration loadingPulse = Duration(milliseconds: 1500);

  /// Orb float - 20s (Background animation)
  static const Duration orbFloat = Duration(seconds: 20);

  /// Orb float reverse - 25s (Secondary orb)
  static const Duration orbFloatReverse = Duration(seconds: 25);

  /// Shimmer - 3s (Light leak effect)
  static const Duration shimmer = Duration(seconds: 3);

  // ============= Hover Animation Configs =============

  /// Card hover animation
  static const Duration cardHoverDuration = normal;
  static const Curve cardHoverCurve = easeOut;
  static const double cardHoverTranslateY = -4.0;
  static const double cardHoverShadowMultiplier = 1.4; // 40% increase

  /// Button hover animation
  static const Duration buttonHoverDuration = fast;
  static const Curve buttonHoverCurve = easeOut;
  static const double buttonHoverTranslateY = -2.0;
  static const double buttonHoverScale = 1.02;
  static const double buttonHoverGlowMultiplier = 1.5; // 50% increase

  /// List item hover animation
  static const Duration listItemHoverDuration = fast;
  static const Curve listItemHoverCurve = easeOut;
  static const double listItemHoverPaddingIncrease = 4.0;

  // ============= Tap/Press Animation Configs =============

  /// Tap feedback scale
  static const Duration tapDuration = instant;
  static const Curve tapCurve = easeInOut;
  static const double tapScale = 0.96;

  // ============= Transition Configs =============

  /// Fade transition
  static const Duration fadeDuration = normal;
  static const Curve fadeCurve = easeDefault;

  /// Slide transition
  static const Duration slideDuration = smoothDuration;
  static const Curve slideCurve = easeOut;

  /// Scale transition
  static const Duration scaleDuration = fast;
  static const Curve scaleCurve = spring;

  // ============= Micro-Interaction Delays =============

  /// Stagger delay between list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Delay before showing tooltips
  static const Duration tooltipDelay = Duration(milliseconds: 500);

  /// Debounce duration for search
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // ============= Page Transition Builders =============

  /// Fade page transition
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Slide from right transition
  static Widget slideFromRightTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: slideCurve)),
    );

    return SlideTransition(position: offsetAnimation, child: child);
  }

  /// Slide from bottom transition (for sheets)
  static Widget slideFromBottomTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(
      tween.chain(CurveTween(curve: slideCurve)),
    );

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Scale and fade transition
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: scaleCurve)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

/// Animation controller helpers
class AppAnimationHelpers {
  AppAnimationHelpers._();

  /// Create a delayed animation
  static Animation<double> createDelayedAnimation({
    required AnimationController controller,
    required double delay, // 0.0 to 1.0
    Curve curve = Curves.easeOut,
  }) {
    final double start = delay;
    final double duration = 1.0 - delay;

    return CurvedAnimation(
      parent: controller,
      curve: Interval(start, start + duration, curve: curve),
    );
  }

  /// Create staggered animations for list items
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int itemCount,
    double staggerDelay = 0.05,
    Curve curve = Curves.easeOut,
  }) {
    return List.generate(itemCount, (index) {
      final delay = index * staggerDelay;
      final clampedDelay = delay.clamp(0.0, 0.8); // Max 80% delay

      return createDelayedAnimation(
        controller: controller,
        delay: clampedDelay,
        curve: curve,
      );
    });
  }
}

/// Preset animation combinations
class AppAnimationPresets {
  AppAnimationPresets._();

  /// Hover animation for cards
  static AnimationController createCardHoverController(TickerProvider vsync) {
    return AnimationController(
      duration: AppAnimations.cardHoverDuration,
      vsync: vsync,
    );
  }

  /// Hover animation for buttons
  static AnimationController createButtonHoverController(TickerProvider vsync) {
    return AnimationController(
      duration: AppAnimations.buttonHoverDuration,
      vsync: vsync,
    );
  }

  /// Tap feedback animation
  static AnimationController createTapController(TickerProvider vsync) {
    return AnimationController(
      duration: AppAnimations.tapDuration,
      vsync: vsync,
    );
  }

  /// Page transition controller
  static AnimationController createPageTransitionController(
    TickerProvider vsync,
  ) {
    return AnimationController(duration: AppAnimations.slow, vsync: vsync);
  }

  /// Loading pulse controller (repeating)
  static AnimationController createLoadingPulseController(
    TickerProvider vsync,
  ) {
    return AnimationController(
      duration: AppAnimations.loadingPulse,
      vsync: vsync,
    )..repeat(reverse: true);
  }

  /// Number count-up animation
  static AnimationController createNumberTickerController(
    TickerProvider vsync,
  ) {
    return AnimationController(
      duration: AppAnimations.numberTicker,
      vsync: vsync,
    );
  }
}
