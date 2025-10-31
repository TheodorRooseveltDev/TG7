import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_animations.dart';

enum ButtonStyle { primary, secondary, outline, text, action }

/// Custom button component with glassmorphism and animations
///
/// Features:
/// - Primary: Gradient background with blue glow
/// - Secondary: Subtle glass background
/// - Outline: Border with transparent background
/// - Action: For floating action buttons
/// - Hover animations: translateY(-2px), scale(1.02), increased glow
/// - Tap feedback: scale(0.96)
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle style;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = ButtonStyle.primary,
    this.icon,
    this.isFullWidth = false,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.buttonHoverDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.buttonHoverCurve,
      ),
    );

    _translateAnimation = Tween<double>(begin: 0.0, end: -2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.buttonHoverCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChange(bool isHovered) {
    if (widget.onPressed == null) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered && !_isPressed) {
      _controller.forward();
    } else if (!_isPressed) {
      _controller.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    setState(() {
      _isPressed = false;
    });
    if (_isHovered) {
      _controller.forward();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() {
      _isPressed = false;
    });
    if (_isHovered) {
      _controller.forward();
    }
  }

  BoxDecoration _getDecoration() {
    switch (widget.style) {
      case ButtonStyle.primary:
        return BoxDecoration(
          gradient: AppColors.primaryButtonGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          boxShadow: _isHovered && !_isPressed
              ? AppShadows.buttonGlowHover
              : (_isPressed
                    ? AppShadows.buttonGlowActive
                    : AppShadows.buttonGlow),
        );
      case ButtonStyle.secondary:
        return BoxDecoration(
          color: AppColors.glassSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          border: Border.all(color: AppColors.glassBorder, width: 1),
        );
      case ButtonStyle.outline:
        return BoxDecoration(
          color: const Color(0x264A7FFF), // rgba(74, 127, 255, 0.15)
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: _isHovered
                ? AppColors.electricBluePrimary.withOpacity(0.5)
                : AppColors.electricBluePrimary.withOpacity(0.3),
            width: 1,
          ),
        );
      case ButtonStyle.text:
        return BoxDecoration(
          color: _isHovered ? AppColors.hoverOverlay : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        );
      case ButtonStyle.action:
        return BoxDecoration(
          gradient: AppColors.primaryButtonGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
          boxShadow: AppShadows.buttonGlow,
        );
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) {
      return AppColors.textDisabled;
    }

    switch (widget.style) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
      case ButtonStyle.action:
        return AppColors.textPrimary;
      case ButtonStyle.outline:
      case ButtonStyle.text:
        return AppColors.electricBluePrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double scale = _isPressed
            ? AppAnimations.tapScale
            : _scaleAnimation.value;

        return Transform.translate(
          offset: Offset(0, _isPressed ? 0 : _translateAnimation.value),
          child: Transform.scale(
            scale: scale,
            child: MouseRegion(
              onEnter: (_) => _onHoverChange(true),
              onExit: (_) => _onHoverChange(false),
              cursor: isDisabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.isLoading ? null : widget.onPressed,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Opacity(
                  opacity: isDisabled ? 0.4 : 1.0,
                  child: Container(
                    width: widget.isFullWidth ? double.infinity : widget.width,
                    height:
                        widget.height ??
                        (widget.style == ButtonStyle.action
                            ? AppSpacing.actionButtonHeight
                            : AppSpacing.primaryButtonHeight),
                    padding:
                        widget.padding ??
                        EdgeInsets.symmetric(
                          horizontal: widget.style == ButtonStyle.text
                              ? AppSpacing.md
                              : AppSpacing.buttonPaddingHorizontal,
                          vertical: AppSpacing.buttonPaddingVertical,
                        ),
                    decoration: _getDecoration(),
                    child: widget.isLoading
                        ? Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTextColor(),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  size: AppSpacing.iconSM,
                                  color: _getTextColor(),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                              ],
                              Flexible(
                                child: Text(
                                  widget.text,
                                  style: widget.style == ButtonStyle.text
                                      ? AppTypography.buttonMediumStyle(
                                          color: _getTextColor(),
                                        )
                                      : AppTypography.buttonLargeStyle(
                                          color: _getTextColor(),
                                        ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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

/// Icon-only button variant
class IconButtonCustom extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const IconButtonCustom({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = AppSpacing.iconMD,
    this.tooltip,
  }) : super(key: key);

  @override
  State<IconButtonCustom> createState() => _IconButtonCustomState();
}

class _IconButtonCustomState extends State<IconButtonCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double scale = _isPressed ? 0.9 : _scaleAnimation.value;

        return Transform.scale(
          scale: scale,
          child: MouseRegion(
            onEnter: (_) {
              if (widget.onPressed != null) {
                setState(() => _isHovered = true);
                _controller.forward();
              }
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _controller.reverse();
            },
            cursor: widget.onPressed == null
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onPressed,
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.hoverOverlay
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color:
                      widget.color ??
                      (widget.onPressed == null
                          ? AppColors.textDisabled
                          : AppColors.textPrimary),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}
