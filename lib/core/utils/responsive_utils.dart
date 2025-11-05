import 'package:flutter/material.dart';

/// Responsive utilities for consistent sizing across devices
class ResponsiveUtils {
  /// Check if device is a tablet (width > 600dp)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  /// Check if device is a large tablet (width > 900dp)
  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, double baseSize) {
    if (isLargeTablet(context)) {
      return baseSize * 1.1;
    } else if (isTablet(context)) {
      return baseSize * 1.05;
    }
    return baseSize;
  }

  /// Get responsive padding
  static double padding(BuildContext context, double basePadding) {
    if (isLargeTablet(context)) {
      return basePadding * 1.5;
    } else if (isTablet(context)) {
      return basePadding * 1.2;
    }
    return basePadding;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    if (isLargeTablet(context)) {
      return baseSize * 1.2;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  /// Get responsive card height
  static double cardHeight(BuildContext context, double baseHeight) {
    if (isLargeTablet(context)) {
      return baseHeight * 1.2;
    } else if (isTablet(context)) {
      return baseHeight * 1.1;
    }
    return baseHeight;
  }

  /// Get max content width for tablets (prevents content from being too wide)
  static double maxContentWidth(BuildContext context) {
    if (isLargeTablet(context)) {
      return 1200;
    } else if (isTablet(context)) {
      return 800;
    }
    return double.infinity;
  }

  /// Get horizontal padding that scales with screen size
  static double screenHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return 48;
    } else if (width >= 900) {
      return 32;
    } else if (width >= 600) {
      return 24;
    }
    return 16; // Reduced from 20 for phones
  }

  /// Get grid column count based on screen width
  static int gridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return 4;
    } else if (width >= 900) {
      return 3;
    } else if (width >= 600) {
      return 2;
    }
    return 2;
  }

  /// Wrap content with max width constraint for tablets
  static Widget constrainWidth(BuildContext context, Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }

  /// Get responsive spacing
  static double spacing(BuildContext context, double baseSpacing) {
    if (isLargeTablet(context)) {
      return baseSpacing * 1.3;
    } else if (isTablet(context)) {
      return baseSpacing * 1.15;
    }
    return baseSpacing;
  }

  /// Get bottom padding considering keyboard
  static double bottomPadding(BuildContext context, {double base = 16}) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    return keyboardHeight > 0 ? base + keyboardHeight : base;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }
}
