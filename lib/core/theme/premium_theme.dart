import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// EXACT Premium Glassmorphic Space Theme
/// Based on Crypto Wallet Design System - FINAL VERSION
class PremiumTheme {
  // 🌐 DEEP SPACE BACKGROUND (EXACT FROM IMAGE)
  static const Color spaceBlackTop = Color(0xFF0A0F1C);
  static const Color deepNavyCenter = Color(0xFF141B2D);
  static const Color deepNavyBottom = Color(0xFF1C2333);

  // 🎨 GLASS MORPHISM SYSTEM (EXACT OPACITIES)
  static const Color glassBase = Color(0x0AFFFFFF); // rgba(255, 255, 255, 0.04)
  static const Color glassMedium = Color(
    0x0DFFFFFF,
  ); // rgba(255, 255, 255, 0.05)
  static const Color glassLight = Color(
    0x14FFFFFF,
  ); // rgba(255, 255, 255, 0.08)
  static const Color borderGlass = Color(
    0x14FFFFFF,
  ); // rgba(255, 255, 255, 0.08)
  static const Color borderGlassLight = Color(
    0x26FFFFFF,
  ); // rgba(255, 255, 255, 0.15)
  static const Color innerHighlight = Color(
    0x26FFFFFF,
  ); // rgba(255, 255, 255, 0.15)

  // 🔵 BLUE-PURPLE GRADIENT SYSTEM (EXACT)
  static const Color primaryBlue = Color(0xFF4A90FF);
  static const Color gradientPurple = Color(0xFF6B5BF6);
  static const Color lightBlue = Color(0xFF6BB5FF);
  static const Color blueGlow = Color(0x594A90FF); // rgba(74, 144, 255, 0.35)
  static const Color blueSoft = Color(0x264A90FF); // rgba(74, 144, 255, 0.15)
  static const Color blueOverlay = Color(
    0x144A90FF,
  ); // rgba(74, 144, 255, 0.08)
  static const Color purpleOverlay = Color(
    0x0D8A2BE2,
  ); // rgba(138, 43, 226, 0.05)

  // 💚 SUCCESS/LOSS COLORS
  static const Color successGreen = Color(0xFF4CD964);
  static const Color successGlow = Color(
    0x1F4CD964,
  ); // rgba(76, 217, 100, 0.12)
  static const Color successBorder = Color(
    0x334CD964,
  ); // rgba(76, 217, 100, 0.2)
  static const Color lossRed = Color(0xFFFF3B30);
  static const Color lossGlow = Color(0x1FFF3B30);

  // 📝 TEXT HIERARCHY (EXACT FROM IMAGE)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(
    0xB3FFFFFF,
  ); // rgba(255, 255, 255, 0.7)
  static const Color textTertiary = Color(
    0x99B8C5E0,
  ); // rgba(184, 197, 224, 0.6)
  static const Color textQuaternary = Color(
    0x80B8C5E0,
  ); // rgba(184, 197, 224, 0.5)
  static const Color textMuted = Color(0x808791AF); // rgba(135, 145, 175, 0.5)

  // 🎯 FLOATING TAB BAR (EXACT)
  static const Color tabBarBase = Color(0x661E2337); // rgba(30, 35, 55, 0.4)
  static const Color tabIconInactive = Color(
    0x998791AF,
  ); // rgba(135, 145, 175, 0.6)

  // 🎨 COIN GRADIENTS
  static LinearGradient get bitcoinGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7931A), Color(0xFFFFB84D)],
  );

  static LinearGradient get ethereumGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF627EEA), Color(0xFF8299F0)],
  );

  static LinearGradient get stellarGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E1E), Color(0xFF4A4A4A)],
  );

  // 🌟 BACKGROUND GRADIENTS
  static LinearGradient get spaceBackground => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [spaceBlackTop, deepNavyCenter, deepNavyBottom],
    stops: [0.0, 0.5, 1.0],
  );

  // 🔵 BLUE-PURPLE GRADIENT (For buttons and active states)
  static LinearGradient get bluePurpleGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, gradientPurple],
  );

  // 🌈 GRADIENT TEXT (Balance display)
  static LinearGradient get balanceTextGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFB8C5E0)],
  );

  // 🎨 GLASS BUTTON GRADIENT OVERLAY
  static LinearGradient get glassButtonOverlay => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0x14FFFFFF), // rgba(255, 255, 255, 0.08)
      const Color(0x05FFFFFF), // rgba(255, 255, 255, 0.02)
    ],
  );

  // 🌟 GLOWING ORB GRADIENT
  static RadialGradient get glowingOrbGradient => RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [
      const Color(0x804A90FF), // rgba(74, 144, 255, 0.5)
      const Color(0x4D4A90FF), // rgba(74, 144, 255, 0.3)
      const Color(0x264A90FF), // rgba(74, 144, 255, 0.15)
      const Color(0x1A8A2BE2), // rgba(138, 43, 226, 0.1)
      Colors.transparent,
    ],
    stops: const [0.0, 0.2, 0.4, 0.6, 0.8],
  );

  // 🎨 THEME DATA
  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: spaceBlackTop,
      primaryColor: primaryBlue,
      fontFamily: '.SF Pro Display',

      // Text Theme with THIN weights
      textTheme: const TextTheme(
        // Balance display - 56px, weight 200 ULTRA THIN
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w200,
          color: textPrimary,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        // Large numbers - 32px, weight 300
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        // Stat values - 22px, weight 600
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        // Section headers - 16px, weight 600
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        // Card text - 15px, weight 600
        headlineSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        // Button text - 15px, weight 600
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        // Regular text - 14px, weight 500
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        // Small labels - 13px, weight 500
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textTertiary,
          letterSpacing: 0.3,
        ),
        // Tiny labels - 13px, weight 400
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
        // Caption - 11px, weight 400
        bodySmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: glassBase,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderGlass, width: 1),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondary, size: 24),

      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: gradientPurple,
        surface: glassBase,
        error: lossRed,
      ),
    );
  }

  // 🎨 UNIVERSAL GLASS BOX DECORATION
  static BoxDecoration glassBox({
    double borderRadius = 20,
    bool hasBorder = true,
    Color? customBackground,
    List<Color>? gradientColors,
  }) {
    return BoxDecoration(
      gradient: gradientColors != null
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                customBackground ?? glassBase,
                (customBackground ?? glassBase).withOpacity(0.5),
              ],
            ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder ? Border.all(color: borderGlass, width: 1) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // 🎨 FLOATING TAB BAR DECORATION (EXACT SPECS)
  static BoxDecoration get floatingTabBarDecoration => BoxDecoration(
    color: tabBarBase,
    borderRadius: BorderRadius.circular(floatingNavBorderRadius), // PILL SHAPE
    border: Border.all(color: borderGlassLight, width: 1),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [blueOverlay, purpleOverlay],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.6),
        blurRadius: 50,
        offset: const Offset(0, 25),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
      BoxShadow(color: blueOverlay, blurRadius: 16, offset: const Offset(0, 8)),
    ],
  );

  // 🎨 GRADIENT BUTTON DECORATION (Blue-Purple gradient)
  static BoxDecoration get gradientButtonDecoration => BoxDecoration(
    gradient: bluePurpleGradient,
    borderRadius: BorderRadius.circular(23),
    border: Border.all(color: borderGlassLight, width: 1),
    boxShadow: [
      BoxShadow(color: blueGlow, blurRadius: 24, offset: const Offset(0, 12)),
      BoxShadow(
        color: const Color(0x4D6B5BF6), // rgba(107, 91, 246, 0.3)
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // 🎨 GLASS ACTION BUTTON (Multi-layer)
  static BoxDecoration get glassActionButton => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0x0FFFFFFF), // rgba(255, 255, 255, 0.06)
        const Color(0x05FFFFFF), // rgba(255, 255, 255, 0.02)
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderGlass, width: 1),
  );

  // 🎨 PERCENTAGE BADGE (Profit)
  static BoxDecoration get profitBadgeDecoration => BoxDecoration(
    color: successGlow,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: successBorder, width: 1),
  );

  // 🎨 PERCENTAGE BADGE (Loss)
  static BoxDecoration get lossBadgeDecoration => BoxDecoration(
    color: lossGlow,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: const Color(0x33FF3B30), // rgba(255, 59, 48, 0.2)
      width: 1,
    ),
  );

  // 🎨 ASSET CARD DECORATION
  static BoxDecoration assetCardDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0x08FFFFFF), // rgba(255, 255, 255, 0.03)
        const Color(0x03FFFFFF),
      ],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: const Color(0x0FFFFFFF), // rgba(255, 255, 255, 0.06)
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // 📏 EXACT SPACING CONSTANTS
  static const double screenHorizontalPadding = 24.0;
  static const double floatingNavBottomMargin = 20.0;
  static const double floatingNavHorizontalMargin = 16.0;
  static const double floatingNavHeight = 80.0; // BIGGER HEIGHT
  static const double floatingNavBorderRadius =
      40.0; // PILL SHAPE (half of height)

  // 🎯 EXACT SHADOWS
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<Shadow> get balanceTextShadow => [
    Shadow(color: blueGlow, blurRadius: 20, offset: const Offset(0, 2)),
  ];

  static List<Shadow> get iconGlowShadow => [
    Shadow(
      color: const Color(0xCC4A90FF), // rgba(74, 144, 255, 0.8)
      blurRadius: 12,
      offset: Offset.zero,
    ),
  ];

  // 🎨 ADDITIONAL DECORATIONS
  static BoxDecoration get actionButtonDecoration => glassActionButton;

  static BoxDecoration get iconContainerDecoration =>
      BoxDecoration(color: blueSoft, borderRadius: BorderRadius.circular(12));
}
