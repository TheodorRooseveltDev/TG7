import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Complete theme configuration for Casino Companion
class AppTheme {
  AppTheme._();

  /// Main theme data for the app
  static ThemeData get darkTheme => ThemeData(
    // Basic theme settings
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.electricBluePrimary,
      primaryContainer: AppColors.electricBlueDark,
      secondary: AppColors.successGreen,
      secondaryContainer: AppColors.secondaryBackground,
      surface: AppColors.secondaryBackground,
      error: AppColors.errorRed,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textPrimary,
      outline: AppColors.glassBorder,
    ),

    // Scaffold background
    scaffoldBackgroundColor: AppColors.primaryBackground,

    // App bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.headingLStyle(),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),

    // Text theme
    textTheme: AppTypography.textTheme,

    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.secondaryBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
      ),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.electricBluePrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        ),
        textStyle: AppTypography.buttonLargeStyle(),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.electricBluePrimary,
        textStyle: AppTypography.buttonMediumStyle(
          color: AppColors.electricBluePrimary,
        ),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.electricBluePrimary,
        side: const BorderSide(color: AppColors.electricBluePrimary, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        ),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0x08FFFFFF), // rgba(255, 255, 255, 0.03)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        borderSide: const BorderSide(
          color: AppColors.electricBluePrimary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputPaddingHorizontal,
        vertical: AppSpacing.inputPaddingVertical,
      ),
      hintStyle: AppTypography.inputStyle(color: AppColors.textQuaternary),
      labelStyle: AppTypography.labelStyle(),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.glassPrimary,
      selectedItemColor: AppColors.electricBluePrimary,
      unselectedItemColor: AppColors.textQuaternary,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTypography.tabStyle(isActive: true),
      unselectedLabelStyle: AppTypography.tabStyle(isActive: false),
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.electricBluePrimary,
      foregroundColor: AppColors.textPrimary,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
      ),
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.glassBorder,
      thickness: AppSpacing.dividerThin,
      space: 0,
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: AppSpacing.iconMD,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0x0DFFFFFF), // rgba(255, 255, 255, 0.05)
      deleteIconColor: AppColors.textTertiary,
      disabledColor: AppColors.textDisabled,
      selectedColor: AppColors.electricBluePrimary,
      secondarySelectedColor: AppColors.electricBlueDark,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      labelStyle: AppTypography.badgeStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.secondaryBackground,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
      ),
      titleTextStyle: AppTypography.headingLStyle(),
      contentTextStyle: AppTypography.bodyMStyle(),
    ),

    // Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.secondaryBackground,
      modalBackgroundColor: AppColors.secondaryBackground,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXL),
        ),
      ),
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.tertiaryBackground,
      contentTextStyle: AppTypography.bodyMStyle(),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
    ),
  );
}
