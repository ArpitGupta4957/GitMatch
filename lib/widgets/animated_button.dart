import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/spacing.dart';

class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? iconWidget;
  final bool isLoading;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;

  const AnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.isLoading = false,
    this.fullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.height,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      listenable: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          if (!widget.isLoading) widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height ?? 56,
          decoration: BoxDecoration(
            gradient: widget.backgroundColor == null
                ? AppColors.accentGradient
                : null,
            color: widget.backgroundColor,
            borderRadius: AppSpacing.buttonRadius,
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? AppColors.accent)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize:
                widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                if (widget.iconWidget != null) ...[
                  widget.iconWidget!,
                  const SizedBox(width: 12),
                ] else if (widget.icon != null) ...[
                  Icon(widget.icon, color: widget.textColor ?? Colors.white, size: 22),
                  const SizedBox(width: 12),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor ?? Colors.white,
                  ),
                ),
                if (!widget.fullWidth) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward,
                      color: widget.textColor ?? Colors.white, size: 20),
                ] else ...[
                  const SizedBox(width: 12),
                  Icon(Icons.arrow_forward,
                      color: widget.textColor ?? Colors.white, size: 20),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }

  @override
  Animation<double> get listenable => super.listenable as Animation<double>;
}
