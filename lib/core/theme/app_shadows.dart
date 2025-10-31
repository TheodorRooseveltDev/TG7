import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ultra-detailed shadow and elevation system for Casino Companion
class AppShadows {
  AppShadows._();

  // ============= Elevation System =============

  /// Level 0 - Base (no shadow)
  static const List<BoxShadow> level0 = [];

  /// Level 1 - Card
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x26000000), // rgba(0, 0, 0, 0.15)
      blurRadius: 8.0,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Level 2 - Raised
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x33000000), // rgba(0, 0, 0, 0.2)
      blurRadius: 16.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Level 3 - Modal
  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x40000000), // rgba(0, 0, 0, 0.25)
      blurRadius: 32.0,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Level 4 - Dropdown
  static const List<BoxShadow> level4 = [
    BoxShadow(
      color: Color(0x4D000000), // rgba(0, 0, 0, 0.3)
      blurRadius: 48.0,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  /// Level 5 - Floating
  static const List<BoxShadow> level5 = [
    BoxShadow(
      color: Color(0x66000000), // rgba(0, 0, 0, 0.4)
      blurRadius: 60.0,
      offset: Offset(0, 20),
      spreadRadius: 0,
    ),
  ];

  // ============= Glow Effects =============

  /// Primary button glow
  static const List<BoxShadow> buttonGlow = [
    BoxShadow(
      color: Color(0x664A7FFF), // rgba(74, 127, 255, 0.4)
      blurRadius: 24.0,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Button glow on hover (stronger)
  static const List<BoxShadow> buttonGlowHover = [
    BoxShadow(
      color: Color(0x804A7FFF), // rgba(74, 127, 255, 0.5)
      blurRadius: 36.0,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  /// Button glow on active (weaker)
  static const List<BoxShadow> buttonGlowActive = [
    BoxShadow(
      color: Color(0x4D4A7FFF), // rgba(74, 127, 255, 0.3)
      blurRadius: 16.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============= Card Glow (on hover) =============

  /// Subtle card glow
  static const List<BoxShadow> cardGlowSubtle = [
    BoxShadow(
      color: Color(0x1A4A7FFF), // rgba(74, 127, 255, 0.1)
      blurRadius: 40.0,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  /// Medium card glow
  static const List<BoxShadow> cardGlowMedium = [
    BoxShadow(
      color: Color(0x264A7FFF), // rgba(74, 127, 255, 0.15)
      blurRadius: 60.0,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  /// Strong card glow
  static const List<BoxShadow> cardGlowStrong = [
    BoxShadow(
      color: Color(0x334A7FFF), // rgba(74, 127, 255, 0.2)
      blurRadius: 80.0,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  // ============= Status Glows =============

  /// Success glow
  static const List<BoxShadow> successGlow = [
    BoxShadow(
      color: Color(0x4D4AE87C), // rgba(74, 232, 124, 0.3)
      blurRadius: 20.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Error glow
  static const List<BoxShadow> errorGlow = [
    BoxShadow(
      color: Color(0x4DFF5E5E), // rgba(255, 94, 94, 0.3)
      blurRadius: 20.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Warning glow
  static const List<BoxShadow> warningGlow = [
    BoxShadow(
      color: Color(0x4DFFB84A), // rgba(255, 184, 74, 0.3)
      blurRadius: 20.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============= Glass Effects =============

  /// Primary glass shadow (outer + inset simulation)
  static const List<BoxShadow> glassPrimary = [
    // Outer shadow
    BoxShadow(
      color: Color(0x4D000000), // rgba(0, 0, 0, 0.3)
      blurRadius: 32.0,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Inner highlight for glass (to be used with DecoratedBox)
  static BoxDecoration get glassDecoration => BoxDecoration(
    gradient: AppColors.glassCardGradient,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.glassBorder, width: 1),
    boxShadow: glassPrimary,
  );

  /// Glass decoration with custom radius
  static BoxDecoration glassDecorationCustom({
    required double borderRadius,
    List<BoxShadow>? shadows,
  }) => BoxDecoration(
    gradient: AppColors.glassCardGradient,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: AppColors.glassBorder, width: 1),
    boxShadow: shadows ?? glassPrimary,
  );

  // ============= Inner Shadows (Text Shadows for Inset Effect) =============

  /// Inset shadow simulation for text
  static const List<Shadow> insetTextShadow = [
    Shadow(
      color: Color(0x4D000000), // rgba(0, 0, 0, 0.3)
      offset: Offset(0, 2),
      blurRadius: 4.0,
    ),
  ];

  // ============= Helper Methods =============

  /// Create custom glow with color
  static List<BoxShadow> customGlow({
    required Color color,
    double blurRadius = 24.0,
    double opacity = 0.4,
    Offset offset = const Offset(0, 8),
  }) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blurRadius,
      offset: offset,
      spreadRadius: 0,
    ),
  ];

  /// Combine multiple shadow lists
  static List<BoxShadow> combine(List<List<BoxShadow>> shadowLists) {
    return shadowLists.expand((list) => list).toList();
  }

  /// Get game-specific glow
  static List<BoxShadow> gameGlow(String gameType) {
    final color = AppColors.getGameColor(gameType);
    return customGlow(color: color, opacity: 0.3);
  }
}

/// Blur effect configurations
class AppBlur {
  AppBlur._();

  /// Minimal blur - 4px (Subtle depth)
  static const double minimal = 4.0;

  /// Light blur - 8px (Background elements)
  static const double light = 8.0;

  /// Medium blur - 12px (Glass overlays)
  static const double medium = 12.0;

  /// Heavy blur - 20px (Primary glass)
  static const double heavy = 20.0;

  /// Maximum blur - 40px (Background orbs)
  static const double maximum = 40.0;

  /// Extreme blur - 80px (Atmospheric effects)
  static const double extreme = 80.0;

  /// For gradient orbs - 100-120px
  static const double orbBlur = 100.0;
}
