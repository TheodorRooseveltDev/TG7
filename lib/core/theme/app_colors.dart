import 'package:flutter/material.dart';

/// Ultra-detailed color system for Casino Companion
/// Based on neo-morphic glassmorphism with dark mode foundation
class AppColors {
  AppColors._();

  // ============= Background Colors =============

  /// Deep space navy - almost black with blue undertones
  static const Color primaryBackground = Color(0xFF0A0E1A);

  /// Slightly lighter navy for cards
  static const Color secondaryBackground = Color(0xFF12172B);

  /// Card hover states
  static const Color tertiaryBackground = Color(0xFF1A1F35);

  /// Elevated surfaces
  static const Color quaternaryBackground = Color(0xFF252B45);

  // ============= Glass Effects Backgrounds =============

  /// Main glass panels - rgba(18, 23, 43, 0.85)
  static const Color glassPrimary = Color(0xD912172B);

  /// Secondary overlays - rgba(30, 36, 58, 0.75)
  static const Color glassSecondary = Color(0xBF1E243A);

  /// Hover states - rgba(42, 50, 78, 0.65)
  static const Color glassTertiary = Color(0xA62A324E);

  /// Subtle glass edges - rgba(255, 255, 255, 0.08)
  static const Color glassBorder = Color(0x14FFFFFF);

  // ============= Accent Colors =============

  /// Main CTA buttons
  static const Color electricBluePrimary = Color(0xFF4A7FFF);

  /// Hover states
  static const Color electricBlueLight = Color(0xFF6B95FF);

  /// Pressed states
  static const Color electricBlueDark = Color(0xFF2B5CE6);

  /// Glow effect - 60% opacity
  static const Color electricBlueGlow = Color(0x994A7FFF);

  // ============= Gradients =============

  /// Primary button gradient
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5E8BFF), Color(0xFF3A6FE8)],
  );

  /// Glass card gradient
  static const LinearGradient glassCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF), // rgba(255, 255, 255, 0.1)
      Color(0x0DFFFFFF), // rgba(255, 255, 255, 0.05)
    ],
  );

  /// Background orb gradient (for radial)
  static const List<Color> backgroundOrbGradient = [
    Color(0xFF4A7FFF), // Center at 0%
    Color(0xFF2B5CE6), // Mid at 40%
    Color(0x00000000), // Edge at 100% (transparent)
  ];

  static const List<double> backgroundOrbStops = [0.0, 0.4, 1.0];

  // ============= Text Colors =============

  /// Primary text - 100% opacity
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text - 85% opacity
  static const Color textSecondary = Color(0xD9FFFFFF);

  /// Tertiary text - 65% opacity
  static const Color textTertiary = Color(0xA6FFFFFF);

  /// Quaternary text - 45% opacity
  static const Color textQuaternary = Color(0x73FFFFFF);

  /// Disabled text - 25% opacity
  static const Color textDisabled = Color(0x40FFFFFF);

  // ============= Status Colors =============

  /// Success green
  static const Color successGreen = Color(0xFF4AE87C);

  /// Success glow color
  static const Color successGlow = Color(0x4D4AE87C);

  /// Error red
  static const Color errorRed = Color(0xFFFF5E5E);

  /// Warning orange
  static const Color warningOrange = Color(0xFFFFB84A);

  /// Info blue
  static const Color infoBlue = Color(0xFF4AA8FF);

  // ============= Game-specific Accent Colors =============

  /// Slots - Golden
  static const Color slotsGold = Color(0xFFFFD700);

  /// Blackjack - Deep Red
  static const Color blackjackRed = Color(0xFFDC143C);

  /// Poker - Green Felt
  static const Color pokerGreen = Color(0xFF00A86B);

  /// Roulette - Burgundy
  static const Color rouletteBurgundy = Color(0xFF800020);

  /// Craps - Dice White
  static const Color crapsWhite = Color(0xFFF5F5F5);

  // ============= Interactive State Colors =============

  /// Overlay for pressed states
  static const Color pressedOverlay = Color(0x1AFFFFFF);

  /// Overlay for hover states
  static const Color hoverOverlay = Color(0x0DFFFFFF);

  /// Focus outline
  static const Color focusOutline = electricBluePrimary;

  // ============= Chart Colors =============

  static const List<Color> chartColors = [
    electricBluePrimary,
    successGreen,
    warningOrange,
    infoBlue,
    Color(0xFFFF6B9D),
    Color(0xFFC77DFF),
  ];

  // ============= Helper Methods =============

  /// Get game color by game type
  static Color getGameColor(String gameType) {
    switch (gameType.toLowerCase()) {
      case 'slots':
        return slotsGold;
      case 'blackjack':
        return blackjackRed;
      case 'poker':
        return pokerGreen;
      case 'roulette':
        return rouletteBurgundy;
      case 'craps':
        return crapsWhite;
      default:
        return electricBluePrimary;
    }
  }

  /// Get gradient for game type
  static LinearGradient getGameGradient(String gameType) {
    final color = getGameColor(gameType);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, Color.lerp(color, Colors.black, 0.3)!],
    );
  }

  /// Get status color with appropriate opacity
  static Color getStatusColor(bool isPositive, [double opacity = 1.0]) {
    return isPositive
        ? successGreen.withOpacity(opacity)
        : errorRed.withOpacity(opacity);
  }

  /// Get status background color
  static Color getStatusBackground(bool isPositive) {
    return isPositive
        ? Color(0x264AE87C) // rgba(74, 232, 124, 0.15)
        : Color(0x26FF5E5E); // rgba(255, 94, 94, 0.15)
  }
}
