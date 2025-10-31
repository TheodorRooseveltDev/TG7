import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';

/// Glass morphism card component with backdrop blur and gradient
///
/// Implements the ultra-detailed glassmorphism recipe:
/// - Background gradient from rgba(255, 255, 255, 0.1) to rgba(255, 255, 255, 0.05)
/// - 20px backdrop blur with 150% saturation
/// - 1px border with rgba(255, 255, 255, 0.08)
/// - Inset highlight and outer shadow
class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final List<BoxShadow>? customShadows;
  final Color? customBorderColor;
  final Gradient? customGradient;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.radiusXL,
    this.onTap,
    this.enableHoverEffect = false,
    this.customShadows,
    this.customBorderColor,
    this.customGradient,
  }) : super(key: key);

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _translateAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _translateAnimation = Tween<double>(
      begin: 0.0,
      end: -4.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverChange(bool isHovered) {
    if (!widget.enableHoverEffect) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _translateAnimation.value),
          child: MouseRegion(
            onEnter: (_) => _onHoverChange(true),
            onExit: (_) => _onHoverChange(false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: _isHovered && widget.enableHoverEffect
                      ? AppShadows.cardGlowMedium
                      : (widget.customShadows ?? AppShadows.glassPrimary),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppBlur.heavy,
                      sigmaY: AppBlur.heavy,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient:
                            widget.customGradient ??
                            AppColors.glassCardGradient,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        border: Border.all(
                          color:
                              widget.customBorderColor ??
                              (_isHovered && widget.enableHoverEffect
                                  ? AppColors.glassBorder.withOpacity(0.12)
                                  : AppColors.glassBorder),
                          width: 1,
                        ),
                      ),
                      padding:
                          widget.padding ??
                          const EdgeInsets.all(AppSpacing.cardPadding),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Simpler glass card without hover effects for better performance
class SimpleGlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const SimpleGlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.radiusXL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppShadows.glassPrimary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppBlur.heavy,
            sigmaY: AppBlur.heavy,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.glassCardGradient,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
