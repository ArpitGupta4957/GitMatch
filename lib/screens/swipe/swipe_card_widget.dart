import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class SwipeCardWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback? onTap;

  const SwipeCardWidget({
    super.key,
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.onTap,
  });

  @override
  State<SwipeCardWidget> createState() => _SwipeCardWidgetState();
}

class _SwipeCardWidgetState extends State<SwipeCardWidget> {
  double _dx = 0;
  double _dy = 0;

  @override
  Widget build(BuildContext context) {
    final angle = _dx * 0.001;
    final opacity = (_dx.abs() / 150).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: widget.onTap,
      onPanUpdate: (details) {
        setState(() {
          _dx += details.delta.dx;
          _dy += details.delta.dy;
        });
      },
      onPanEnd: (_) {
        if (_dx > 120) {
          widget.onSwipeRight();
        } else if (_dx < -120) {
          widget.onSwipeLeft();
        }
        setState(() {
          _dx = 0;
          _dy = 0;
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..translateByDouble(_dx, _dy, 0, 0)
          ..rotateZ(angle),
        alignment: Alignment.center,
        child: Stack(
          children: [
            widget.child,
            // Left overlay (REJECT)
            if (_dx < 0)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.swipeReject.withValues(alpha: opacity * 0.2),
                  ),
                ),
              ),
            // Right overlay (SAVE)
            if (_dx > 0)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.swipeSave.withValues(alpha: opacity * 0.2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
