import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class SwipeIndicator extends StatelessWidget {
  final double opacity;
  final bool isRight;

  const SwipeIndicator({
    super.key,
    required this.opacity,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: isRight ? null : 20,
      right: isRight ? 20 : null,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: isRight ? 0.2 : -0.2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isRight ? AppColors.swipeSave : AppColors.swipeReject,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isRight ? 'SAVE' : 'REJECT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isRight ? AppColors.swipeSave : AppColors.swipeReject,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Action buttons row for swipe cards
class SwipeActionButtons extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback? onRefresh;
  final VoidCallback onSave;

  const SwipeActionButtons({
    super.key,
    required this.onReject,
    this.onRefresh,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reject button
        _ActionButton(
          icon: Icons.close,
          color: AppColors.swipeReject,
          size: 56,
          onTap: onReject,
        ),
        if (onRefresh != null) ...[
          const SizedBox(width: 24),
          _ActionButton(
            icon: Icons.refresh,
            color: AppColors.textSecondary,
            size: 44,
            onTap: onRefresh!,
          ),
        ],
        const SizedBox(width: 24),
        // Save button
        _ActionButton(
          icon: Icons.favorite,
          color: AppColors.swipeSave,
          size: 56,
          onTap: onSave,
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: widget.color.withValues(alpha: 0.5), width: 2),
            color: widget.color.withValues(alpha: 0.1),
          ),
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size * 0.45,
          ),
        ),
      ),
    );
  }
}
