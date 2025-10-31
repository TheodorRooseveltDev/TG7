import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ultra-detailed typography system for Casino Companion
/// Font Stack: SF Pro Display (iOS) / Inter (Fallback)
class AppTypography {
  AppTypography._();

  // ============= Font Families =============

  static const String primaryFont = 'SF Pro Display';
  static const String numericFont = 'SF Mono';

  // Flutter will fall back to system fonts automatically
  static const List<String> fontFamilyFallback = [
    'SF Pro Display',
    'Inter',
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Roboto',
  ];

  // ============= Font Sizes =============

  // Display Sizes
  static const double displayXL = 56.0;
  static const double displayL = 40.0;
  static const double displayM = 32.0;
  static const double displayS = 28.0;

  // Heading Sizes
  static const double headingXL = 24.0;
  static const double headingL = 20.0;
  static const double headingM = 18.0;
  static const double headingS = 16.0;

  // Body Sizes
  static const double bodyL = 16.0;
  static const double bodyM = 14.0;
  static const double bodyS = 13.0;
  static const double bodyXS = 12.0;
  static const double bodyXXS = 11.0;

  // ============= Font Weights =============

  static const FontWeight thin = FontWeight.w100;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight black = FontWeight.w900;

  // ============= Line Heights =============

  static const double displayLineHeight = 1.1;
  static const double headingLineHeight = 1.2;
  static const double bodyLineHeight = 1.5;
  static const double captionLineHeight = 1.4;

  // ============= Letter Spacing =============

  static const double tightSpacing = -2.0;
  static const double normalSpacing = 0.0;
  static const double wideSpacing = 0.5;

  // ============= Display Text Styles =============

  /// Main balance display - 56px, Thin
  static TextStyle displayXLStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: displayXL,
    fontWeight: thin,
    height: displayLineHeight,
    letterSpacing: tightSpacing,
    color: color ?? AppColors.textPrimary,
  );

  /// Secondary balance - 40px, Light
  static TextStyle displayLStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: displayL,
    fontWeight: light,
    height: displayLineHeight,
    letterSpacing: tightSpacing,
    color: color ?? AppColors.textPrimary,
  );

  /// Section headers - 32px, Semibold
  static TextStyle displayMStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: displayM,
    fontWeight: semibold,
    height: displayLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  /// Card titles - 28px, Semibold
  static TextStyle displaySStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: displayS,
    fontWeight: semibold,
    height: displayLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  // ============= Heading Text Styles =============

  /// Page titles - 24px, Bold
  static TextStyle headingXLStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: headingXL,
    fontWeight: bold,
    height: headingLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  /// Section titles - 20px, Semibold
  static TextStyle headingLStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: headingL,
    fontWeight: semibold,
    height: headingLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  /// Card headers - 18px, Semibold
  static TextStyle headingMStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: headingM,
    fontWeight: semibold,
    height: headingLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  /// Subsection headers - 16px, Semibold
  static TextStyle headingSStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: headingS,
    fontWeight: semibold,
    height: headingLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  // ============= Body Text Styles =============

  /// Primary content - 16px, Regular
  static TextStyle bodyLStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyL,
    fontWeight: regular,
    height: bodyLineHeight,
    color: color ?? AppColors.textPrimary,
  );

  /// Standard text - 14px, Regular
  static TextStyle bodyMStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyM,
    fontWeight: regular,
    height: bodyLineHeight,
    color: color ?? AppColors.textSecondary,
  );

  /// Secondary text - 13px, Regular
  static TextStyle bodySStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyS,
    fontWeight: regular,
    height: bodyLineHeight,
    color: color ?? AppColors.textTertiary,
  );

  /// Captions - 12px, Regular
  static TextStyle bodyXSStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyXS,
    fontWeight: regular,
    height: captionLineHeight,
    color: color ?? AppColors.textTertiary,
  );

  /// Micro labels - 11px, Regular
  static TextStyle bodyXXSStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyXXS,
    fontWeight: regular,
    height: captionLineHeight,
    color: color ?? AppColors.textQuaternary,
  );

  // ============= Specialized Text Styles =============

  /// Button text - 16px, Bold
  static TextStyle buttonLargeStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyL,
    fontWeight: bold,
    color: color ?? AppColors.textPrimary,
    letterSpacing: wideSpacing,
  );

  /// Small button text - 14px, Semibold
  static TextStyle buttonMediumStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyM,
    fontWeight: semibold,
    color: color ?? AppColors.textPrimary,
    letterSpacing: wideSpacing,
  );

  /// Tab text - 14px, Semibold
  static TextStyle tabStyle({Color? color, bool isActive = false}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyM,
    fontWeight: isActive ? semibold : medium,
    color: color ?? (isActive ? AppColors.textPrimary : AppColors.textTertiary),
  );

  /// Numeric display (balance, amounts) - Uses monospace for alignment
  static TextStyle numericStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) => TextStyle(
    fontFamily: numericFont,
    fontSize: fontSize,
    fontWeight: fontWeight ?? thin,
    height: displayLineHeight,
    letterSpacing: tightSpacing,
    color: color ?? AppColors.textPrimary,
    fontFeatures: const [
      FontFeature.tabularFigures(), // Ensures all numbers have same width
    ],
  );

  /// Input field text - 16px, Regular
  static TextStyle inputStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyL,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  /// Input label - 13px, Medium
  static TextStyle labelStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyS,
    fontWeight: medium,
    color: color ?? AppColors.textSecondary,
  );

  /// Pill/Badge text - 12px, Medium
  static TextStyle badgeStyle({Color? color}) => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyXS,
    fontWeight: medium,
    color: color ?? AppColors.textPrimary,
  );

  // ============= Special Effects =============

  /// Glowing text effect
  static List<Shadow> textGlow({Color? color, double blurRadius = 20.0}) => [
    Shadow(
      color: (color ?? AppColors.electricBluePrimary).withOpacity(0.6),
      blurRadius: blurRadius,
      offset: Offset.zero,
    ),
  ];

  // ============= Material Theme TextTheme =============

  static TextTheme get textTheme => TextTheme(
    // Display
    displayLarge: displayXLStyle(),
    displayMedium: displayLStyle(),
    displaySmall: displayMStyle(),

    // Headline
    headlineLarge: headingXLStyle(),
    headlineMedium: headingLStyle(),
    headlineSmall: headingMStyle(),

    // Title
    titleLarge: headingSStyle(),
    titleMedium: bodyLStyle(color: AppColors.textPrimary),
    titleSmall: bodyMStyle(color: AppColors.textPrimary),

    // Body
    bodyLarge: bodyLStyle(),
    bodyMedium: bodyMStyle(),
    bodySmall: bodySStyle(),

    // Label
    labelLarge: buttonMediumStyle(),
    labelMedium: bodyXSStyle(),
    labelSmall: bodyXXSStyle(),
  );
}
