import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class SwipeStackWidget extends StatefulWidget {
  final List<Widget> cards;
  final Function(int index, bool isRight) onSwipe;

  const SwipeStackWidget({
    super.key,
    required this.cards,
    required this.onSwipe,
  });

  @override
  State<SwipeStackWidget> createState() => _SwipeStackWidgetState();
}

class _SwipeStackWidgetState extends State<SwipeStackWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.cards.length) {
      return const Center(
        child: Text(
          'No more cards!',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      );
    }

    return Stack(
      children: [
        // Next card (background)
        if (_currentIndex + 1 < widget.cards.length)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Opacity(
                opacity: 0.5,
                child: Transform.scale(
                  scale: 0.95,
                  child: widget.cards[_currentIndex + 1],
                ),
              ),
            ),
          ),
        // Current card
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: widget.cards[_currentIndex],
          ),
        ),
      ],
    );
  }

  void swipeLeft() {
    widget.onSwipe(_currentIndex, false);
    setState(() => _currentIndex++);
  }

  void swipeRight() {
    widget.onSwipe(_currentIndex, true);
    setState(() => _currentIndex++);
  }
}
