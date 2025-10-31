import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/premium_theme.dart';
import '../../core/assets/app_assets.dart';

/// EXACT Floating Glass Tab Bar
/// 72px height, 20px bottom, 16px sides, NO TEXT LABELS
/// Heavy 40px blur, gradient overlay, icon gradients when active
class FloatingGlassTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingGlassTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Make navbar narrower - 80% of screen width with max 380px
    final screenWidth = MediaQuery.of(context).size.width;
    final navWidth = (screenWidth * 0.85).clamp(0.0, 360.0);
    final horizontalMargin = (screenWidth - navWidth) / 2;

    return Positioned(
      left: horizontalMargin,
      right: horizontalMargin,
      bottom: PremiumTheme.floatingNavBottomMargin,
      child: Container(
        height: PremiumTheme.floatingNavHeight,
        decoration: PremiumTheme.floatingTabBarDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            PremiumTheme.floatingNavBorderRadius,
          ), // PILL SHAPE
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 40, // EXACT: Heavy 40px blur
              sigmaY: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PremiumTheme.blueOverlay,
                    PremiumTheme.purpleOverlay,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabItem(iconPath: AppAssets.homeIcon, index: 0),
                  _buildTabItem(iconPath: AppAssets.sessionIcon, index: 1),
                  _buildTabItem(iconPath: AppAssets.analyzeIcon, index: 2),
                  _buildTabItem(iconPath: AppAssets.bankrollIcon, index: 3),
                  _buildTabItem(iconPath: AppAssets.moreIcon, index: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({required String iconPath, required int index}) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 56, // Slightly narrower for tighter spacing
        height: PremiumTheme.floatingNavHeight,
        alignment: Alignment.center,
        child: isActive
            ? Container(
                width: 72, // MUCH BIGGER - almost touching navbar edges
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: PremiumTheme.bluePurpleGradient,
                  boxShadow: [
                    BoxShadow(
                      color: PremiumTheme.primaryBlue.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset(
                    iconPath,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  iconPath,
                  color: PremiumTheme.tabIconInactive,
                  fit: BoxFit.contain,
                ),
              ),
      ),
    );
  }
}
