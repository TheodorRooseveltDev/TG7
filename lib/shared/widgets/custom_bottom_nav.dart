import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Custom bottom navigation bar with glassmorphism
///
/// Features:
/// - Glass background with blur
/// - Animated icons and labels
/// - Active indicator line with glow
/// - Smooth transitions between tabs
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.tabBarHeight,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.glassBorder, width: 1)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: AppColors.glassPrimary,
            padding: const EdgeInsets.only(
              top: AppSpacing.tabPaddingVertical,
              bottom: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == currentIndex;

                return _NavBarItem(
                  item: item,
                  isActive: isActive,
                  onTap: () => onTap(index),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final BottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    Key? key,
    required this.item,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _controller.reverse()),
      onTapUp: (_) {
        if (widget.isActive) {
          _controller.forward();
        }
      },
      onTapCancel: () {
        if (widget.isActive) {
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 64,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Active indicator line
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    width: widget.isActive ? 32 : 0,
                    decoration: BoxDecoration(
                      gradient: widget.isActive
                          ? const LinearGradient(
                              colors: [
                                AppColors.electricBluePrimary,
                                AppColors.electricBlueLight,
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(1),
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: AppColors.electricBlueGlow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  // Icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.item.icon,
                      size: AppSpacing.iconMD,
                      color: widget.isActive
                          ? AppColors.electricBluePrimary
                          : AppColors.textQuaternary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTypography.tabStyle(
                      isActive: widget.isActive,
                      color: widget.isActive
                          ? AppColors.electricBluePrimary
                          : AppColors.textQuaternary,
                    ),
                    child: Text(
                      widget.item.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bottom navigation item model
class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({required this.icon, required this.label});
}
